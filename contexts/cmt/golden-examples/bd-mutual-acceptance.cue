package cmt

// bd-mutual-acceptance.cue -- golden-example do CMT (WI-137 / W006).
//
// Instancia de #GoldenExample (adr-145): o experimento spec->codigo que prova P1
// (a spec gera tipos/aggregate/Port-contracts/testes sem edicao semantica). E o
// 1o golden-example do portfolio -> vira o template do fan-out (P3c).
//
// DECLARACAO-PURA (adr-145): zero campo de evidencia; o RESULTADO de rodar vive em
// governance/build-time/codegen-validation-evidence.cue (direcao evidencia->declaracao).
//
// EXECUCAO VIVA DEFERIDA: gerar+compilar+testar exige toolchain (linguagem-alvo +
// gerador CUE->codigo + test runner) que adr-139 deferiu (def-040 open) + o
// mesh-runtime, ausente do escopo. Rastreado por def-055 + gates adr-138.
//
// A #Assertion asrt-mutual-bilateral-acceptance e EMBUTIDA aqui (shared-type sem
// _schema.location proprio): formaliza a prosa de inv-mutual-bilateral-acceptance
// (sc-cmt-01) na gramatica estruturada que o codegen consome.

import (
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
	"github.com/sw6n297mn8-maker/mesh-spec/architecture/shared-schemas:shared_schemas"
)

goldenExample: artifact_schemas.#GoldenExample & {
	id:                  "ge-cmt-mutual-acceptance"
	boundedContextRef:   "cmt"
	businessDecisionRef: "bd-mutual-acceptance"

	specSlice: {
		invariantRefs: ["inv-mutual-bilateral-acceptance"]
		commandRefs: ["cmd-propose-commitment", "cmd-confirm-commitment-acceptance"]
		eventRefs: ["evt-commitment-proposed", "evt-commitment-accepted"]
		aggregateRef: "agg-commitment"
		rationale:    "Recorte microscopico do aceite bilateral: agg-commitment so transiciona para 'accepted' apos ProposeCommitment (fixa referenceTermsHash) + ConfirmCommitmentAcceptance (termsHash == referenceTermsHash), via evt-commitment-proposed/accepted no EventLogPort. Refs ao domain-model do CMT (P0), nunca copia."
	}

	assertionRefs: ["asrt-mutual-bilateral-acceptance"]

	codegenTarget: {
		kinds: ["types", "aggregate-skeleton", "port-contracts", "stubs", "contract-tests", "assertion-tests"]
		rationale: "Cada kind e exercitado pela fatia bilateral: types = value-objects do commitment (CommitmentId, referenceTermsHash, AcceptanceConfirmation, payloads de evt-commitment-proposed/accepted); aggregate-skeleton = agg-commitment + a transicao para 'accepted'; port-contracts = EventLogPort (pm-cmt: append/readStream); stubs = adapter-stub in-memory do EventLogPort (golden-example sobe sem vendor); contract-tests = Tier-1/2 do pm-cmt (error-coverage gerado + OCC comportamental); assertion-tests = derivados de asrt-mutual-bilateral-acceptance. Nenhum kind inflado -- todos tem fonte concreta na fatia."
	}

	gates: {
		continuar:           "Os tipos/aggregate-skeleton/port-contracts gerados COMPILAM E os assertion-tests de asrt-mutual-bilateral-acceptance (>=1 caso valido + >=1 invalido) PASSAM E o EventLogPort e gerado + usado pelo adapter-stub in-memory SEM depender de runtime real (adr-138 item 7)."
		pivotar:             "A spec do CMT nao tem informacao para gerar o aggregate-skeleton de agg-commitment, OU asrt-mutual-bilateral-acceptance nao vira teste executavel sem preenchimento manual -- revisar spec/toolchain (adr-138 item 7)."
		abandonar:           "O output gerado exige EDICAO SEMANTICA MANUAL para compilar ou passar -- viola P1; re-escolher toolchain (adr-138 item 7)."
		p1Strict:            "Edicoes no output gerado sao PROIBIDAS, exceto header de arquivo gerado, configuracao de formatacao, ou scaffolding de adapter temporario documentado FORA do codigo gerado (adr-138 item 7, P1 estrito)."
		falsificationSignal: "Qualquer arquivo gerado editado SEMANTICAMENTE para passar; OU, no fan-out, numero de BCs cuja implementacao diverge estruturalmente deste template > 0 sem ADR justificando (adr-138 falsificationCondition)."
		rationale:           "Gates sao CONDICAO definida ANTES do run (real-options, adr-138 item 7), nunca resultado -- o resultado medido (qual gate atingido) vive em codegen-validation-evidence (execucao deferida)."
	}

	templateRole: {
		isTemplate:       true
		divergencePolicy: "Divergencia estrutural deste template no fan-out (outros BCs) > 0 exige ADR justificando (adr-138 falsificationCondition; P3c)."
		rationale:        "1o golden-example do portfolio; vira o template (P3c de adr-138) que torna o fan-out rapido e consistente -- a declaracao estavel e copiada, a evidencia e por-BC."
	}

	rationale: "Golden-example microscopico do CMT (bd-mutual-acceptance): o experimento spec->codigo que prova P1 -- a spec gera tipos/aggregate/Port-contracts/testes sem edicao semantica manual. Declaracao-pura (adr-145): a evidencia de run vive em codegen-validation-evidence (direcao evidencia->declaracao). Execucao viva deferida (toolchain indecisa adr-139/def-040; mesh-runtime ausente), rastreada por def-055 + gates de adr-138 item 7."
}

// #Assertion embutida: formaliza inv-mutual-bilateral-acceptance (prosa em
// sc-cmt-01) na gramatica estruturada para o codegen derivar property-based
// tests. Referenciada por goldenExample.assertionRefs.
mutualBilateralAcceptanceAssertion: shared_schemas.#Assertion & {
	id:      "asrt-mutual-bilateral-acceptance"
	subject: "Commitment em transicao para o estado 'accepted'"
	variables: [
		{name: "state", source: "aggregate-state", filter: "Commitment.state"},
		{name: "proposerEvidence", source: "event-log", filter: "evt-commitment-proposed (by=proposer) que fixa referenceTermsHash"},
		{name: "counterpartyEvidence", source: "event-log", filter: "evt-commitment-accepted carregando AcceptanceConfirmation (confirmedBy=counterparty)"},
		{name: "referenceTermsHash", source: "event-log", filter: "referenceTermsHash fixado em evt-commitment-proposed"},
		{name: "acceptanceTermsHash", source: "event-log", filter: "AcceptanceConfirmation.termsHash em evt-commitment-accepted"},
	]
	predicate: {
		op: "implies"
		operands: [
			{relation: "eq", left: {var: "state"}, right: {const: "accepted"}},
			{
				op: "and"
				operands: [
					{relation: "exists", left: {var: "proposerEvidence"}},
					{relation: "exists", left: {var: "counterpartyEvidence"}},
					{relation: "eq", left: {var: "acceptanceTermsHash"}, right: {var: "referenceTermsHash"}},
				]
			},
		]
	}
	rationale: "Formaliza inv-mutual-bilateral-acceptance: estado 'accepted' implica evidencia bilateral presente (proponente + contraparte) E termsHash da contraparte == referenceTermsHash do proponente. Aceite unilateral ou hash divergente e irrepresentavel (dp-08 anti-fraude / dp-10 responsabilidade juridica). O codegen deriva >=1 caso valido (ambas evidencias + hash igual) + >=1 invalido (so uma parte OU hash divergente). Limite de fidelidade V1: o predicate captura ESTRUTURALMENTE o hash-match (eq) e a presenca-bilateral (exists+exists). Dois eixos do invariante vivem no filter (prosa), NAO no predicate, logo NAO sao verificados pelo auto-codegen: (a) ator-distinto (proposer != counterparty -- anti-unilateral, sc-cmt-01 forbidden[1]/[3]); (b) mesmo-commitmentId (o invariante e forall commitmentId; sem variavel de join). Resolucao de #VarRef/filter = def-053; quantificacao forall = def-054. INTERINO (def-049): os testes hand-encoded DEVEM encodar ator-distinto + mesmo-commitmentId para preservar a fidelidade. O auto-codegen FUTURO herda o furo ate def-053/054; ate la, auto-codegen puro deste predicate validaria uma APROXIMACAO (passaria aceite unilateral) -- nao usar como prova de fidelidade sem def-053/054 resolvidos."
}
