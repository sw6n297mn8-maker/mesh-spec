package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr186: artifact_schemas.#ADR & {
	id:    "adr-186"
	title: "Adotar o modelo de prova Tekton (v0.4.0) como binding Mesh"
	date:  "2026-08-09"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-cutting"

	context: """
		Estado precedente. O work-governance do mesh-spec carrega um modelo de
		prova/conclusão próprio, nascido em adr-183/184/185: #EffectProof
		{repo, commit, gate, conclusion} situado no #CompletionValidation
		(adr-184 dec 4), o discriminador effectExpectedIn com #SubordinateRepo
		— enumeração fechada {mesh-runtime, mesh-frontend-runtime} em
		architecture/shared-types/task-output.cue (dec 2) — e task-reconciled
		founder-exclusivo (adr-183). Esse modelo tem estatuto epistêmico
		declarado: prova apresentada, não verificada (adr-184 dec 6). def-084
		registrou exatamente essa lacuna — o mesh-spec grava
		(repo, commit, gate, conclusion) e não confere que o commit existe no
		alvo nem que o gate concluiu como alegado; o que fica deferido é o
		verificador (o leitor determinístico), com trigger sobre volume de uso
		(effectExpectedIn >=3 em task-specs), hoje zero no disco.

		Trigger. Esse conhecimento battle-tested da Mesh subiu ao core genérico
		do Tekton: adr-009 + round-2 (adr-010) transformaram o efeito-como-prova,
		a reconciliation e o fan-out em ontologia genérica governada —
		#ProofRequirement/#ProofResult/#VerifierRef + um Verifier Registry
		event-sourced (identidade por digest, capability != authority, lifecycle
		forward-only) + a catraca de admissão #TaskAdmissionV2 que prova, em
		cue vet, que todo verifierRef resolve para versão ativa no registry. Foi
		cortado como release v0.4.0 @ 0de85b3 (âncora canônica, repo-state,
		ADR-002). A Mesh agora precisa re-adotar esse genérico como fonte
		canônica e reconciliar seu modelo paralelo contra ele; caso contrário o
		portfólio carrega dois sistemas de prova (drift por construção, viola P0)
		e o verificador que a resolução de def-084 exige nunca materializa — o
		genérico nasceu do Mesh, re-divergir é perda.

		Fronteira de escopo. A Mesh não é adotante virgem do motor Tekton: tem
		motor próprio (work-governance.cue, completion-gates.cue) e não depende
		do módulo tekton. Logo esta decisão adota o vocabulário genérico (dois
		schemas-folha, re-homed no package artifact_schemas local — sem colisão
		de nomes verificada, imports stdlib-only, byte-idênticos), declara o
		binding Mesh contra o motor existente, e reinterpreta adr-183/184/185 —
		mas não substitui o #EffectProof vivo nem roteia a completion pela
		catraca. Essa materialização e enforcement são trabalho de motor
		rastreado por M-182; misturá-los aqui daria crédito de enforcement antes
		da catraca existir.

		Alternativas avaliadas.
		(a) Não adotar — manter o #EffectProof paralelo do Mesh como sistema
		próprio. Rejeitada: dois sistemas de prova no portfólio violam P0
		(localização canônica única); e deixam def-084 permanentemente sem o
		verificador que sua resolução exige.
		(b) Fork / adoção divergente (extended/forked com divergência local do
		vocabulário). Rejeitada: sem necessidade demonstrada de divergência — o
		genérico já incorpora o battle-tested Mesh; fork importaria custo de
		manutenção cross-repo sem ganho, contra FP-02 do Tekton (promoção por
		evidência — o Mesh é a evidência que subiu).
		(c) Adotar o motor inteiro (work-governance.cue verbatim). Rejeitada:
		mecanicamente inviável (Mesh não depende do módulo tekton; o arquivo
		importa cross-module) e importaria superfície muito além de M-184 — o
		Mesh já tem motor; adota-se o vocabulário, implementa-se o binding.
		(d) Adotar E fechar def-084 no mesmo commit (materializar o enforcement
		agora). Rejeitada: substituir o #EffectProof no motor vivo + rotear pela
		catraca é trabalho substancial (work-governance + completion-gates), fora
		de uma ADR de adoção; separar decide/materializa preserva a honestidade
		de não creditar enforcement inexistente (a mesma disciplina que def-084
		exige).
		"""

	decision: """
		(1) ADOTAR o vocabulário genérico de prova, verbatim e pinado. Estender
		governance/adopted-artifacts.cue com duas entries adoptionMode
		"verbatim", sourceVersion "0.4.0" + sourceCommitHash 0de85b30..., re-homed
		no package artifact_schemas local:
		portfolio/artifact-schemas/evidence-types.cue ->
		architecture/artifact-schemas/evidence-types.cue e
		portfolio/artifact-schemas/verifier-types.cue ->
		architecture/artifact-schemas/verifier-types.cue. Adota-se o vocabulário
		(#ProofRequirement/#ProofResult/#Subject/#SourceRef/#Conclusion/#EvidenceRef
		+ #VerifierRef/#VerifierRegistry e eventos/grants); o motor Mesh não é
		adotado.

		(2) DECLARAR o binding Mesh do genérico adotado — nomeando normativamente
		as responsabilidades que o core Tekton deixa ao resolver do adotante, sem
		materializá-las (M-182):
		(a) authority-surface resolver — resolve a superfície de autoridade
		relevante para decidir se um subjectRef está dentro ou fora da autoridade
		direta do declarador;
		(b) reconciliation authority binding — resolve a autoridade terminal
		competente para ReconcileTask; na Mesh, adr-183 preserva a
		founder-exclusividade concreta;
		(c) identity/actor mapping — usa adr-182 para ligar identidades/atores
		concretos às autoridades do binding;
		(d) materialization-detail policy — as propriedades do assertionPayload
		que constituem detalhe de materialização sob autoridade do executor (não
		só path: também outputFile, manifestLocation, targetArtifact e
		equivalentes) e portanto são proibidas cross-authority — a parede
		(adr-010 N2);
		(e) #SubordinateRepo + runtimes concretos, preservando a enumeração
		fechada de adr-184 (mesh-runtime, mesh-frontend-runtime);
		(f) id-format Mesh.

		(3) REINTERPRETAR adr-183/184/185 como binding do genérico adotado — em
		linguagem de interpretação, não de lifecycle: generic authority
		transferred to Tekton (efeito-como-prova, task-reconciled-como-conceito e
		fan-out passam a ter fonte canônica no contrato Tekton adotado) /
		Mesh-specific authority preserved (#SubordinateRepo/runtimes,
		effectExpectedIn e projeções/UX compatíveis, founder-exclusividade
		concreta seguem vigentes). Os três permanecem accepted enquanto contiverem
		conteúdo normativo concreto ainda vigente. supersedes fica vazio. A
		supersessão relacional de qualquer um deles só poderá ocorrer quando todo
		o seu conteúdo normativo tiver sido substituído ou reapresentado por outra
		autoridade — condição que pode nunca se cumprir mesmo com o #EffectProof
		morto; M-182 não recebe obrigação automática de supersedê-los.

		(4) FIXAR a condição de resolução de def-084 (que permanece open):
		resolved somente quando o motor Mesh (M-182) substituir o gate nominal
		(#EffectProof.gate: string) pela referência governada ao verifier e
		implementar, no caminho obrigatório de admission/completion, as
		invariantes normativas de #TaskAdmissionV2 — não o type concreto: (i) todo
		verifier usado resolve para (id, version, revision) registrado e ativo no
		Verifier Registry adotado; (ii) verifiers mandatórios são cobertos; (iii)
		referência ausente / inválida / inativa rejeita fail-closed. A shape do
		motor Mesh pode diferir; a equivalência normativa com o contrato adotado
		deve ser explícita e testável. Não creditar enforcement à mera presença do
		Registry. O resolvedBy será o artefato/ADR que M-182 materializar (não um
		work-item).
		"""

	consequences: """
		Positivas.
		P1 — Fonte canônica única do modelo de prova: o portfólio deixa de
		carregar dois sistemas (o genérico Tekton adotado e o #EffectProof
		paralelo Mesh convergem), fechando o drift-por-construção que P0 proíbe.
		P2 — A resolução de def-084 ganha alvo concreto: o verificador deixa de
		ser "capacidade a construir do zero" e passa a "adotar o Verifier Registry
		+ rotear pela catraca" — trabalho de M-182 com contrato definido.
		P3 — Baixo atrito e reversível: o vocabulário entra como schema dormente
		(sem _schema.location, fora do coveredSchemas whitelist de sc-pg-01, sem
		instância) — nenhum custo de CI, nenhuma production-guide exigida.
		P4 — adr-183/184/185 ganham fundação genérica sob si sem perder o
		concreto: a reinterpretação preserva founder-exclusividade,
		#SubordinateRepo e effectExpectedIn.
		P5 — A fronteira QUE=spec / COMO=runtime (adr-148/157) é respeitada:
		adota-se o contrato, não o motor; runtimes subordinados permanecem
		soberanos.

		Negativas.
		N1 — Janela de dualidade temporária: entre adr-186 e M-182 o #EffectProof
		paralelo ainda vive no motor Mesh; a convergência é declarada, não
		materializada, e def-084 permanece open (afirmação vs enforcement é gap
		conhecido, rastreado).
		N2 — Schema dormente é superfície presente sem consumidor: dois arquivos
		que só ganham sentido em M-182 — risco de "adotado e esquecido" se M-182
		não vier (mitigado por def-084 open + trigger de volume + o binding
		declarado como pressão de continuidade).
		N3 — Custo de adoção verbatim: futuras evoluções do modelo de prova no
		Tekton exigem re-adoção pinada (double-anchor), acoplando a v0.4.0 com
		disciplina de bump.
		N4 — A equivalência normativa (não type-import) transfere a M-182 o ônus
		de provar que o motor Mesh preserva as invariantes de #TaskAdmissionV2 —
		mais trabalho que um import literal, deliberadamente (evita tradução
		"inspirada").
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se a implementação do binding Mesh não
			conseguir preservar as invariantes normativas do modelo de prova
			Tekton adotado sem manter ou recriar uma segunda autoridade de prova.
			"""
		observableSignal: """
			M-182 exige divergência semântica não representável como binding; OU
			precisa manter #EffectProof/gate nominal como autoridade paralela; OU
			os testes de equivalência mostram uma classe de TaskSpec aceita pelo
			motor Mesh que seria rejeitada pelas invariantes adotadas — ou
			vice-versa, sem decisão Mesh explícita que justifique a diferença.
			"""
	}

	affectedArtifacts: [
		"governance/adopted-artifacts.cue",
	]

	plannedOutputs: [
		"architecture/artifact-schemas/evidence-types.cue",
		"architecture/artifact-schemas/verifier-types.cue",
	]

	principlesApplied: ["P0", "P1", "P10", "P14"]

	supersedes: []

	rationale: """
		A decisão aplica P0 no seu núcleo: dois sistemas de prova no portfólio são
		drift por construção; adotar o genérico e referenciar (não copiar o motor)
		mantém uma localização canônica única — o contrato Tekton pinado — com o
		Mesh apontando. P1: o vocabulário adotado é contrato CUE source-of-truth,
		contra o qual M-182 implementa/gera o motor, nunca escreve divergente à
		mão. P10: a parede e def-084 são gate determinístico, não julgamento — por
		isso def-084 só fecha com a catraca no caminho obrigatório (fail-closed),
		nunca pela mera presença do Registry; agente apresenta, gate valida. P14:
		o modelo tem dentes compile-time (cue vet: verifierRef -> versão ativa é
		invariante estrutural) e runtime-only coberto por gate determinístico (a
		verificação de efeito cross-repo) — exatamente a divisão P14; a adoção traz
		esses dentes ao Mesh como contrato, e M-182 os preserva no motor.

		Escolheu-se adoção-de-vocabulário + declaração-de-binding +
		equivalência-normativa-testável em vez de import-de-motor porque o Mesh já
		tem motor e não depende do módulo tekton (alternativa (c) inviável e
		sobre-importadora). A reinterpretação de adr-183/184/185 é linguagem de
		interpretação, não de lifecycle: generic authority transferred to Tekton,
		Mesh-specific authority preserved; os três seguem accepted enquanto
		carregarem norma Mesh vigente. Em contexto cross-repo, isto realiza FP-02
		do Tekton (promoção por evidência — o Mesh é a evidência que subiu), agora
		re-ancorada como binding.

		reversibility medium — não há migração irreversível de dados nem contrato
		público consumido externamente, mas a decisão altera a autoridade
		normativa do modelo de prova e prepara dependências explícitas para M-182.
		Reverter exige coordenar a remoção das duas adoções pinadas, dos dois
		schemas locais, desfazer a reinterpretação de adr-183/184/185 e
		reestabelecer uma autoridade alternativa para o modelo de prova; portanto
		o custo é moderado, não trivial. Não é low porque nada é irreversível, nem
		high porque a reversão exige trabalho coordenado e restauração semântica.
		blastRadius cross-cutting — atravessa adoção, vocabulário de prova e a
		semântica de completion (reinterpretação cross-domínio), sem tocar
		CI/estrutura repo-wide.
		"""
}
