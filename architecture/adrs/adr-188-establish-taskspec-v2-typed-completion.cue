package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr188: artifact_schemas.#ADR & {
	id:    "adr-188"
	title: "Estabelecer #TaskSpecV2 e #CompletionValidationV2 com evidência tipada"
	date:  "2026-08-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		Estado precedente. adr-186 adotou o vocabulário de prova Tekton
		(#ProofRequirement/#ProofResult/#VerifierRef) e adr-187 estabeleceu o
		Verifier Registry + verifier-governance (não-operacional). O motor Mesh
		ainda descreve completion por #CompletionValidation V1 com #EffectProof
		{repo, commit, gate, conclusion} (o gate: string nominal) +
		effectExpectedIn/#SubordinateRepo. adr-186 declarou o binding mas não
		materializou a shape Mesh de V2 — que M-182 pede ("schema CUE canônico da
		tarefa Mesh"). Há 75 work-events com completionValidation V1 + os
		task-specs V1 vivos.

		Trigger. Ligar o modelo de prova adotado ao motor exige uma tarefa V2 que
		carregue requiredEvidence (#ProofRequirement com verifierRef) e uma
		completion V2 que carregue proofResults (#ProofResult) — substituindo a
		rota nominal do #EffectProof.gate. Mas o legado V1 não pode regredir.
		Verificamos empiricamente (cue) que uma união validante V1 | V2 tornaria
		as instâncias V1 incompletas sob cue vet — logo V2 deve coexistir com V1
		congelado como definição separada, não como ramo de união.

		Alternativas avaliadas.
		(a) União validante versionada (#TaskSpec: V1|V2, #CompletionValidation:
		V1|V2). Rejeitada por teste empírico: V1-data resolve como V1-completo |
		V2-incompleto → cue vet marca "incomplete" (as 75 instâncias V1
		quebrariam); discriminador defaulted nos dois lados não resolve; só um
		discriminador obrigatório em V1 resolveria — forçando migrar todo o
		legado. Definições separadas = zero-regression.
		(b) Binding in-place (enxertar requiredEvidence/proofResults no
		#EffectProof/#TaskSpec V1). Rejeitada: muta V1 (viola congelamento) e
		prolonga a autoridade paralela que adr-186 aposentou.
		(c) Preservar effectExpectedIn como campo em V2. Rejeitada: cria duas
		autoridades da mesma expectativa (effectExpectedIn +
		requiredEvidence[].subjectRef), exigindo um invariante de coerência entre
		elas; a semântica migra para #ProofRequirement como autoridade única.
		(d) Materializar sem ADR (só a shape). Rejeitada: a shape Mesh de V2, a
		ponte de effectExpectedIn e o mecanismo de coexistência são decisão
		semântica nova que adr-186 não tomou — exige registro.
		"""

	decision: """
		(1) ESTABELECER #TaskSpecV2 como definição nova coexistente com #TaskSpec
		V1 (congelado, intocado): campos de identidade da tarefa +
		requiredEvidence!: [...#ProofRequirement] & list.MinItems(1) + um
		discriminador de versão explícito obrigatório (specVersion!: "v2") que a
		autoidentifica — a propriedade travada é "V2 autoidentificável por versão
		explícita; V1 não ganha marcador retroativo". semanticPrerequisites MANTÉM
		[...string] (paridade com V1) — a indicação de #SourceRef para prerequisites
		vive só em comentário do leaf adotado, não em shape normativa adotada (item
		7); adotar #SourceRef aqui seria mudança guiada por comentário, não por
		contrato. O tipo #SourceRef adotado permanece disponível para uso local
		futuro, se um driver próprio surgir.

		(2) ESTABELECER #CompletionValidationV2 como definição nova coexistente com
		#CompletionValidation V1 (congelado): proofResults!: [...#ProofResult] &
		list.MinItems(1) + discriminador de versão explícito obrigatório
		(validationVersion!: "v2"). Nenhuma rota V2 por #EffectProof — a prova V2 é
		#ProofResult (carrega verifierRef + evidenceRef + conclusion).

		(3) POLÍTICA DE SUPERFÍCIE E LOCUS em V2 (normativa aqui, não só no CUE):
		outputs declara EXCLUSIVAMENTE materializações sob autoridade DIRETA da
		tarefa (#LocalOutputV2: artifact + type; SEM ramo remoto). Qualquer
		consequência FORA dessa superfície direta é declarada EXCLUSIVAMENTE como
		requiredEvidence (#ProofRequirement — com subjectRef quando carrega locus).
		Isto continua a parede do adr-186/185: o spec declara a consequência
		observável, nunca ordena a materialização sob autoridade do executor.
		effectExpectedIn permanece SÓ em V1; V2 NÃO o reintroduz como campo
		normativo paralelo.
		HONESTIDADE sobre subjectRef: este slice NÃO adiciona refinamento
		compile-time Mesh de subjectRef além do #Subject genérico já adotado
		(#ResourceRef | #ResourceSelector). Restringir estruturalmente os loci
		válidos (e.g. a #SubordinateRepo) exigiria identificar quais requirements
		SÃO de-efeito (propriedade derivada da capability do verifier — logo
		Registry-dependente) E a authority surface concreta; ambos pertencem ao
		resolver do Slice C. B fixa subjectRef como a autoridade única do locus
		(sem segundo campo concorrente), mas não materializa nenhuma restrição de
		locus além do schema genérico adotado.

		(4) FIXAR em V2 todas as invariantes decidíveis apenas a partir do contrato
		e dos resultados presentes (fail-closed no schema, sem Registry):
		requiredEvidence obrigatório e não-vazio; cada requirement com verifierRef;
		proofResults obrigatório e não-vazio; nenhuma rota por #EffectProof. Estas
		invariantes de RELAÇÃO materializam-se num terceiro tipo — o join estrutural
		#TaskCompletionV2 — que liga requiredEvidence (de #TaskSpecV2) a
		proofResults (de #CompletionValidationV2) e exige, testado como fail-closed
		sob cue vet -c:
		  (4a) COBERTURA + CONCLUSÃO + VERIFIER CORRETO — para todo requirement r,
		  existe proofResult p tal que p.requirementId == r.id E p.conclusion ==
		  "verified" E p.verifierRef IGUAL a r.verifierRef componente-a-componente
		  (id, version, revision — a identidade normativa de #VerifierRef; NÃO se
		  presume == sobre struct). Um result verified pelo verifier ERRADO não
		  satisfaz o requirement.
		  (4b) NO ORPHAN — todo proofResult.requirementId referencia um requirement
		  realmente declarado em requiredEvidence.
		A regra de conclusão preserva a tricotomia #Conclusion como VOCABULÁRIO do
		#ProofResult (verified | rejected | indeterminate são valores válidos),
		distinta da regra de COMPLETION (só "verified" satisfaz — rejected e
		indeterminate NÃO completam). A resolução de verifierRef para versão
		ATIVA/AUTORIZADA no Registry e qualquer adjudicação dependente do Registry
		pertencem ao Slice C, que ESTENDE #TaskCompletionV2.

		(5) NÃO criar união validante V1|V2 sobre o legado; disjunção por
		construção (discriminador de versão obrigatório + closedness — provado: dado
		V1-completo, unificar com V2 é _|_; dado V2-completo, unificar com V1 é
		_|_). Regra de consumo: uma união V1|V2 só pode existir num ponto NOVO de
		consumo que não force instâncias V1 históricas a resolução ambígua; a
		admission de Slice C DEVE exigir V2 explicitamente, nunca um #AnyTaskSpec
		genérico por conveniência.

		(6) DECLARAR a barreira B↔C: #TaskSpecV2 é autorável/validável como
		contrato agora, mas não-elegível para uso produtivo/admission até Slice C
		ativar o Registry e a catraca fail-closed born-reject. Consistente com
		adr-187 (Registry não-operacional).

		(7) BINDING-LOCATION INTERPRETATION (fronteira de adoção). As referências a
		governance/build-time/work-governance.cue presentes nos COMENTÁRIOS do
		architecture/artifact-schemas/evidence-types.cue (adotado verbatim)
		descrevem a materialização do modelo no repositório de ORIGEM Tekton; NÃO
		constituem requisito de localização física do binding Mesh. A Mesh adota a
		semântica e os TIPOS declarados (vocabulário + invariantes); a MORADA da sua
		materialização é decisão local do binding. adr-188 estabelece
		governance/build-time/task-spec-v2.cue como essa morada — arquivo novo,
		separado do work-governance.cue (V1 congelado), por razão estrutural própria
		(isolar V1 de V2, tornar o sunset observável), NÃO por conveniência.
		Pelo MESMO princípio, a nota (também em comentário, evidence-types.cue linha
		60) de que semanticPrerequisites "passa a #SourceRef" descreve intenção de
		materialização do source, não shape normativa adotada — verificado: a única
		ocorrência de semanticPrerequisites nos arquivos adotados é comentário,
		nenhuma definição/constraint vincula o campo a #SourceRef. Regra geral desta
		fronteira: um path ou wiring presente em comentário de leaf adotado verbatim
		NÃO adquire autoridade normativa sobre o downstream; o que se adota é
		semântica, tipos e invariantes — a topologia física do source NÃO é adotada.
		Isto resolve explicitamente a colisão detectada no self-review (uq-04): não
		é drift silencioso, é interpretação formal da boundary de adoção.
		"""

	consequences: """
		Positivas.
		P1 — A tarefa Mesh ganha um contrato V2 de prova tipada ligando o
		vocabulário adotado; a rota nominal #EffectProof.gate é substituída, em V2,
		por #ProofResult (que carrega verifierRef).
		P2 — Zero regressão: V1 congelado coexiste; as 75 completions V1 + os
		task-specs V1 ficam intocados (a alternativa de união os tornaria
		incompletos sob cue vet — verificado empiricamente).
		P3 — Dentes compile-time máximos: coverage requirement→result, verifier
		CORRETO componente-a-componente (id/version/revision — result pelo verifier
		errado não completa), no-orphan (result sem requirement declarado é
		rejeitado), regra de conclusão (só verified completa), não-vacuidade e
		verifierRef presente são fail-closed no tipo agora (testados via cue vet -c:
		1 caso positivo + 6 negativos + 2 de disjunção), não empurrados para
		runtime. Só a adjudicação Registry-dependente é deferida.
		P4 — Autoridade única do locus + superfície local restrita: subjectRef é a
		única representação normativa do locus (sem effectExpectedIn paralelo
		exigindo invariante de coerência); e outputs V2 declara SÓ materializações
		sob autoridade direta (#LocalOutputV2), empurrando toda consequência externa
		para requiredEvidence — a parede do adr-186/185 preservada por construção.
		P5 — Fronteira B↔C limpa: V2 é autorável/validável como contrato; admission
		+ resolução Registry ficam em C. V2 não-operacional até C (consistente com
		adr-187).
		P6 — Fronteira de adoção esclarecida (reutilizável): fica formal que
		path/wiring em COMENTÁRIO de leaf adotado verbatim NÃO governa a topologia
		do downstream — adota-se semântica, tipos e invariantes, não a organização
		física do source. Evita que cada comentário source-specific de um schema
		verbatim vire obrigação estrutural para todo adotante. Preserva verbatim
		real (zero edição do arquivo adotado) e a separação física V1/V2 escolhida
		por razão própria.

		Negativas.
		N1 — V2 existe mas é não-produtivo até Slice C (sem admission; Registry
		não-operacional): contrato autorável, mas nenhuma tarefa o usa
		produtivamente ainda.
		N2 — Duas famílias de tipo coexistem (V1 + V2) até a eventual aposentadoria
		de V1 — período de dualidade (mitigado: V1 congelado, discriminador
		explícito, sem união ambígua).
		N3 — O terceiro tipo (join de completion) adiciona superfície; mas é o
		mínimo para a semântica decidida existir de verdade — não scope creep.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se a coexistência por definições separadas
			não puder ser consumida pelos próximos pontos de enforcement sem
			reintroduzir uma união ambígua sobre o legado, ou se alguma invariante
			de completion que seja decidível exclusivamente a partir de
			requiredEvidence e proofResults tiver sido deixada fora do binding V2.
			"""
		observableSignal: """
			Slice C precisa obrigar instâncias V1 históricas a atravessar uma união
			V1|V2 para operar; ou um caso negativo construível apenas com
			#TaskSpecV2 + #CompletionValidationV2 é aceito apesar de violar
			coverage, conclusão, verifier-correto (id/version/revision) ou no-orphan
			— sem qualquer dependência de estado do Registry.
			"""
	}

	affectedArtifacts: []

	plannedOutputs: [
		"governance/build-time/task-spec-v2.cue",
	]

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: ["P0", "P1", "P10", "P14"]

	supersedes: []

	rationale: """
		P14 é o princípio central: coverage, regra de conclusão, não-vacuidade e
		verifierRef-presente são invariantes compile-time-forçadas (provadas por
		cue vet -c), e o único deferimento — resolução de verifier ativo/autorizado
		— é genuinamente runtime-only (depende de estado operacional do Registry).
		É a classificação-por-demonstração de P14: não empurrar para runtime o que o
		tipo elimina agora. P0 — localização canônica única / zero duplicação:
		subjectRef como autoridade única do locus (sem segundo campo concorrente;
		outputs V2 restrito a materialização local, consequência externa só em
		requiredEvidence); a coexistência V1/V2 preserva o legado canônico sem
		quebra (a união foi rejeitada por teste empírico porque tornaria as 75
		instâncias V1 incompletas); e a fronteira de adoção fica explícita —
		adota-se semântica, tipos e invariantes do vocabulário de prova, mas NÃO a
		topologia física do source: path e wiring que vivem apenas em comentário do
		leaf adotado verbatim (a morada em work-governance.cue; a nota
		semanticPrerequisites→#SourceRef) descrevem a materialização Tekton e não
		governam o binding Mesh (item 7). A morada local (task-spec-v2.cue) e a
		manutenção de semanticPrerequisites como [...string] decorrem disso — não
		deixar comentário adquirir autoridade normativa por acidente.
		P1 — schemas CUE como source of truth: o contrato V2 é CUE como autoridade
		normativa; qualquer projeção ou codegen futuro deriva dela, nunca uma shape
		escrita divergente à mão (este slice não liga consumidor derivado — apenas
		fixa a autoridade). P10 — agentes recomendam, gates validam: os dentes
		estruturais (coverage, verifier-correto, no-orphan, conclusão, não-vacuidade)
		são gate determinístico no tipo; nada de vacuidade.

		reversibility medium — aditivo e sem consumidor hoje, mas fixa o contrato
		canônico V2 que a admission de Slice C assume; reverter é unwind de
		governança, não trivial. blastRadius cross-artifact — o change altera a
		relação entre o motor e os tipos de prova adotados; admission, enforcement e
		Registry-operacional não entram no caminho de execução neste slice.
		A morada em novo arquivo (governance/build-time/task-spec-v2.cue) separa por
		fronteira física a superfície histórica V1 congelada (work-governance.cue,
		intocado) da superfície normativa V2 nova, reduzindo risco de edição
		acidental de V1 e tornando o eventual sunset observável.
		"""
}
