package build_time

import (
	"list"

	as "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
)

// task-spec-v2.cue — Contrato V2 da tarefa Mesh com evidência tipada (adr-188).
//
// Coexiste com #TaskSpec/#CompletionValidation V1 (work-governance.cue,
// CONGELADOS, intocados). NENHUMA união validante V1|V2 sobre o legado:
// disjunção por construção (discriminador de versão obrigatório + closedness).
// V2 é autorável/validável como contrato AGORA. O Registry está ativo
// (adr-189) e a catraca born-reject de admission existe como CONTRATO
// (#TaskAdmissionV2, adr-192, abaixo); uso produtivo depende de executor
// operacional que a consuma — fronteira seguinte (adr-192 dec 9).

// #LocalOutputV2 — output SOB AUTORIDADE DIRETA da tarefa (materialização
// local). V2 NÃO carrega ramo remoto: a expectativa de efeito fora da
// superfície direta do spec migra INTEIRAMENTE para requiredEvidence
// (#ProofRequirement.subjectRef), autoridade única do locus (adr-188 item 3).
// Diferença normativa vs V1 #TaskOutput (que tinha ramo effectExpectedIn).
#LocalOutputV2: {
	artifact!: string & !=""
	type!:     "create" | "update" | "validate"
}

// #TaskSpecV2 — definição nova, autoidentificável por specVersion!: "v2"
// (V1 não ganha marcador retroativo). semanticPrerequisites mantém [...string]
// (paridade com V1): a indicação de #SourceRef vive SÓ em comentário do leaf
// adotado (evidence-types.cue linha 60), não em shape normativa adotada — logo
// não governa o binding Mesh (adr-188 item 7, binding-location interpretation).
#TaskSpecV2: {
	specVersion!: "v2"
	id!:          string & =~"^WI-[0-9]{3}$"
	version!:     int & >=1
	title!:       string & !=""
	templateRef!: string & =~"^tmpl-[a-z][a-z0-9-]*@v[0-9]+$"

	semanticPrerequisites!: [...string & !=""]

	outputs!: [...#LocalOutputV2]
	affects!: [...string & !=""]

	// requiredEvidence — AUTORIA de prova (adr-009 D2). Obrigatório e não-vazio:
	// uma tarefa V2 declara ao menos uma exigência de prova tipada. O
	// load-bearing é verifierRef; sem proofKind.
	requiredEvidence!: [...as.#ProofRequirement] & list.MinItems(1)

	rationale!: string & !=""
}

// #CompletionValidationV2 — completion nova, autoidentificável por
// validationVersion!: "v2". A prova V2 é #ProofResult (carrega verifierRef +
// evidenceRef + conclusion); NENHUMA rota por #EffectProof (gate nominal).
#CompletionValidationV2: {
	validationVersion!:   "v2"
	validationRunId!:     string & !=""
	artifactSnapshotHash!: string & !=""
	gatesPassed!:         [string & !="", ...string & !=""]

	proofResults!: [...as.#ProofResult] & list.MinItems(1)
}

// #TaskCompletionV2 — join estrutural de completion: liga requiredEvidence
// (de #TaskSpecV2) a proofResults (de #CompletionValidationV2). Materializa
// as invariantes decidíveis SÓ do contrato + resultados presentes, fail-closed
// no schema, SEM Registry (adr-188 item 4). A resolução de verifierRef para
// versão ATIVA/AUTORIZADA no Registry e qualquer adjudicação Registry-dependente
// pertencem ao Slice C, que ESTENDE este join.
#TaskCompletionV2: {
	taskSpec!:   #TaskSpecV2
	completion!: #CompletionValidationV2

	// ids dos requirements declarados.
	_reqIds: [for r in taskSpec.requiredEvidence {r.id}]

	// COBERTURA + CONCLUSÃO + VERIFIER CORRETO: para todo requirement r existe
	// proofResult p com p.requirementId==r.id, p.conclusion=="verified", e
	// verifierRef IDÊNTICO componente-a-componente (id, version, revision — a
	// identidade normativa de #VerifierRef; == em struct não é presumido). Erra
	// sob cue vet -c quando falta cobertura, conclusão!=verified, ou verifier
	// divergente.
	_coveredByRightVerifier: [for r in taskSpec.requiredEvidence {
		true & list.Contains([
			for p in completion.proofResults
			if p.requirementId == r.id
			if p.conclusion == "verified"
			if p.verifierRef.id == r.verifierRef.id
			if p.verifierRef.version == r.verifierRef.version
			if p.verifierRef.revision == r.verifierRef.revision {p.requirementId}
		], r.id)
	}]

	// NO ORPHAN: todo proofResult referencia um requirement realmente declarado.
	_noOrphan: [for p in completion.proofResults {true & list.Contains(_reqIds, p.requirementId)}]

	// ── RESOLUÇÃO DE IDENTIDADE DE VERIFIER (adr-190), via abstração ÚNICA ──
	// A regra (exact-ref ∧ active ∧ compatible-grant) vive em #VerifierResolution
	// (verifier-resolution.cue, adr-191) — este join CONSOME a definição canônica,
	// não a redefine. O Registry é parâmetro TIPADO (adr-190 dec 9): é o
	// compilador que impede chamador de passar valor fora das invariantes —
	// inclusive register-once (dec 10), do qual a resolução depende sem
	// reimplementar.
	registry!: as.#VerifierRegistry

	// Declaração canônica de consumerhood (adr-190 item 11), ANINHADA.
	_verifierResolutionConsumer: "task-completion-v2"

	_resolution: #VerifierResolution & {"registry": registry}

	// RESOLUÇÃO EXIGIDA (dec 8), calculada REQUIREMENT-SIDE. O motivo é
	// estrutural, não de força: _coveredByRightVerifier já torna
	// requirement↔proof uma relação TOTAL e REF-EXATA (adr-188), logo provar que
	// todo requirement aponta para verifier resolvível implica o mesmo para todo
	// proof que o satisfaz — sem repetir o join sobre proofResults. NÃO se alega
	// rejeição no ato da autoria: C2 é completion; admission é assunto de C3.
	_verifierResolves: (_resolution.resolve & {
		refs: [for r in taskSpec.requiredEvidence {r.verifierRef}]
	}).out
}

// #TaskAdmissionV2 — join de ADMISSION: task × template × registry (adr-192;
// born-reject prometido por adr-188 item 6 / adr-189). Duas relações:
//  (1) COBERTURA: mandatoryVerifiers(template) ⊆ verifierIds(requiredEvidence).
//      Campo opcional no template (compat com instâncias existentes); quando
//      presente, cobertura é obrigatória — sem este join, mandatoryVerifiers
//      seria campo declarativo inerte (o que o D7 do protocolo proíbe).
//  (2) RESOLVABILITY: todo verifierRef declarado resolve pela MESMA abstração
//      #VerifierResolution consumida pela completion (adr-191) — admission e
//      completion NÃO PODEM divergir sobre "resolve?": consomem literalmente a
//      mesma definição. NENHUMA lógica de resolução é copiada para cá.
// Admission NÃO substitui completion: satisfaz-se na ENTRADA (a task pode ser
// admitida e ainda falhar completion por cobertura/conclusão — adr-188).
#TaskAdmissionV2: {
	task!:     #TaskSpecV2
	template!: as.#TaskTemplate
	registry!: as.#VerifierRegistry

	// Declaração canônica de consumerhood (adr-190 item 11), ANINHADA.
	_verifierResolutionConsumer: "task-admission-v2"

	// COERÊNCIA DE IDENTIDADE: o template passado É o que a task referencia —
	// sem isto, as relações seriam prováveis contra um template arbitrário.
	_templateMatches: true & (task.templateRef == "\(template.id)@v\(template.version)")

	_declaredVerifierIds: [for r in task.requiredEvidence {r.verifierRef.id}]

	// (1) cobertura de mandatoryVerifiers (template pode omitir o campo).
	_mandatoryCovered: [if template.mandatoryVerifiers != _|_
		for mv in template.mandatoryVerifiers {
			true & list.Contains(_declaredVerifierIds, mv.verifierId)
		}]

	// (2) resolvability pela abstração canônica — instancia, não copia.
	_resolution: #VerifierResolution & {"registry": registry}
	_verifiersResolve: (_resolution.resolve & {
		refs: [for r in task.requiredEvidence {r.verifierRef}]
	}).out
}
