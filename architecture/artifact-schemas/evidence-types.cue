package artifact_schemas

// evidence-types.cue — Tipos de evidência tipada verificável para
// #TaskSpecV2 e #CompletionValidationV2 (per adr-009).
//
// Type-library limpa (sem _schema.location próprio): todos os tipos são
// embutidos em outros schemas — #TaskSpecV2.requiredEvidence e
// #CompletionValidationV2.proofResults vivem em
// governance/build-time/work-governance.cue (package build_time) via
// import de artifact_schemas. Isenção "utility" registrada em
// _exemptions.cue.
//
// Régua de design (adr-009): o load-bearing de uma prova é o verifierRef
// — a identidade do adjudicador governado. Não há proofKind: classificação
// que o motor não consulta para decidir comportamento é proibida.
//
// ── Normas do modelo de prova — round-2 (adr-010, extends adr-009) ──
// Estas normas NÃO mudam o shape de nenhum tipo abaixo (#ProofRequirement,
// #ProofResult, #Subject, #EvidenceRef permanecem idênticos). São invariantes
// interpretativos que o adr-010 incorpora do conhecimento battle-tested da
// Mesh (mesh-spec adr-183/184/185 como ORIGEM, não erro do adr-009).
//
// N1 (D1 — efeito dobra na ontologia de prova): efeito produzido fora da
// superfície/autoridade direta do spec NÃO é hierarquia paralela nem um
// effectKind. É uma ESPECIALIZAÇÃO de #ProofRequirement/#ProofResult:
//   - subjectRef = locus/recurso alvo do efeito (#Subject: identidade ou
//     seleção — nunca um path de artefato do executor);
//   - assertionPayload = a consequência observável esperada, cujo shape é
//     definido pelo assertionSchemaRef de um verifier DE EFEITO;
//   - evidenceRef = commit | digest | observation; conclusion = tricotomia.
// A "efeito-ness" vive no SCHEMA/capability do verifier, não numa tag no
// requirement. Detecção é derivada (do verifier), não declarada por rótulo.
//
// N1.1 (D1.1 — contextualidade do evidenceRef): evidenceRef NÃO precisa ser
// globalmente autossuficiente. É interpretado no contexto do #ProofRequirement
// que ProofResult.requirementId referencia. O locus canônico pertence ao
// subjectRef do requirement; DUPLICAR o locus dentro do evidenceRef é PROIBIDO,
// salvo quando a evidência tem identidade externa intrínseca (namespace/URI por
// natureza) — nunca só para repetir o subject. O contrato do verifier recebe
// requirement + result e interpreta o evidenceRef no locus do subjectRef.
//
// N4 (D4 — fan-out por seleção): quando o efeito incide sobre um conjunto
// não-enumerável ex-ante, subjectRef usa #ResourceSelector (já existente) e um
// verifier de COBERTURA adjudica que o efeito valeu sobre o conjunto. Fan-out é
// capacidade do modelo de evidência — NÃO um novo task-kind nem type novo.
//
// N2 (D2 — a parede): para efeitos produzidos FORA da autoridade/superfície
// direta do spec, o requirement declara a CONSEQUÊNCIA OBSERVÁVEL, nunca o
// detalhe de materialização sob autoridade do executor (não só campos chamados
// "path" — qualquer outputFile/targetArtifact/manifestLocation etc.). O core
// NÃO decide sozinho se o subject está "fora": é o resolver do binding (padrão
// affect-coherence do adr-009). Enforcement é PARAMETRIZADO pelo binding via
// #EffectWallPolicy (abaixo); ativação reusa o extension point existente
// (assertionSchemaRef → schema do binding), SEM taxonomia de capability.

// #GitCommit — SHA git (curto ou completo).
#GitCommit: string & =~"^[0-9a-f]{7,40}$"

// #SourceRef — referência de fonte pinada a revisão imutável (D4).
// git é um caso; tracker é outro. semanticPrerequisites de #TaskSpecV2
// deixa de ser string livre e passa a #SourceRef.
#GitSourceRef: {
	kind!:   "git"
	repo!:   string & =~"^[^/]+/[^/]+$"
	ref!:    string & !=""
	commit!: #GitCommit
}

#TrackerSourceRef: {
	kind!:     "tracker"
	tracker!:  string & !=""
	issue!:    string & !=""
	revision!: string & !=""
}

#SourceRef: #GitSourceRef | #TrackerSourceRef

// #Subject — sujeito sobre o qual uma prova incide (D3, subjectRef).
// Item singular (#ResourceRef) ou seleção (#ResourceSelector).
#ResourceRef: {
	id!:   string & !=""
	kind!: string & !=""
}

#ResourceSelector: {
	selector!:   string & !=""
	exclusions?: [...#ResourceRef]
}

#Subject: #ResourceRef | #ResourceSelector

// #ProofRequirement — exigência de prova declarada em autoria (D2).
// requiredEvidence é AUTORIA, distinta de acceptance (verdade semântica,
// motor NÃO verifica) e de proofResult (execução). O load-bearing é
// verifierRef; não há proofKind.
#ProofRequirement: {
	id!:              string & =~"^req-[a-z0-9-]+$"
	verifierRef!:     #VerifierRef
	assertionPayload!: {...}
	subjectRef?:      #Subject
	rationale!:       string & !=""
}

// #Conclusion — veredito tricotômico (D3). indeterminate NUNCA completa:
// roteia para a resolution policy referenciada. No vacuous verification.
#Conclusion: "verified" | "rejected" | "indeterminate"

// #EvidenceRef — ponteiro para a evidência material observada.
#EvidenceRef: {
	kind!:  "git" | "digest" | "observation"
	value!: string & !=""
}

// #ProofResult — resultado de execução de uma prova (D2). A declaração do
// executor não decide; um adjudicador autorizado e independente decide
// segundo seu contrato governado (FP-10).
#ProofResult: {
	requirementId!: string & =~"^req-[a-z0-9-]+$"
	verifierRef!:   #VerifierRef
	evidenceRef!:   #EvidenceRef
	observedAt!:    string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$"
	conclusion!:    #Conclusion
	rationale?:     string
}

// A materialização de #EffectWallPolicy foi DELIBERADAMENTE OMITIDA (adr-010,
// D2, Stop Condition opção 2). A norma da parede (N2 acima) e as
// responsabilidades core × binding são FIXADAS normativamente no adr-010; a
// SHAPE concreta de ativação/enforcement NÃO é congelada aqui porque o Tekton
// ainda não tem plumbing genérico de resolver capaz de PROVAR que os quatro
// conhecimentos necessários (authority-surface, resource-relation, assertion-
// schema, materialization-detail) resolvem. Congelar quatro strings agora seria
// aparência de enforcement, não enforcement — e obrigaria uma descoberta futura
// sobre resolver plumbing a preservar/migrar uma interface reconhecidamente
// não-validável. Um follow-on resolve a infraestrutura de enforcement ANTES que
// qualquer adotante possa declarar a wall-policy ativa. Até lá, fail-closed é
// requisito normativo do adr-010, não um type prematuro.
