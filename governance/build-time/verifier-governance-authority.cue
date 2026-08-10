package build_time

import (
	"list"

	as "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"
)

// verifier-governance-authority.cue — Superfície de autoridade de mutação do
// domínio verifier-governance (adr-189 decisões 1 e 2).
//
// AUTORIZAÇÃO ≠ EVENTO PERSISTIDO. Este artefato governa a DECISÃO de mutar
// (quem pode autorizar uma mutação do trust root, sob qual classe de decisão);
// o Registry (verifier-registry.cue) armazena o FATO ocorrido
// (#VerifierRegistryEvent). Um evento já-ocorrido NUNCA é autorização para
// fazê-lo ocorrer.
//
// DISTINTO de command-rights.cue: aquele é keyed por #CommandType de TAREFA e
// classifica por #EffectClass de efeito de tarefa — verificado em adr-189
// (investigação a) que nenhum dos 6 representa governança de trust root, e que
// reusá-los seria semanticamente falso. Este é keyed pelas AÇÕES do domínio.
//
// NÃO toca o schema adotado verbatim (architecture/artifact-schemas/
// verifier-types.cue): o vocabulário de AÇÃO é Mesh-local; os event types
// adotados NÃO são reusados como se fossem comandos.
//
// AUTORIDADE ≠ EXECUÇÃO (adr-187 item 2): founder-held é quem DECIDE autorizar;
// não implica que o founder execute a mutação.
//
// LIMITE DECLARADO DO QUE ESTE ARTEFATO PROVA: ele torna explícita e exaustiva a
// correspondência normativa entre caminhos de mutação e ações autorizáveis (a
// exaustividade é enforçada por scripts/ci/check-verifier-governance-coverage.sh).
// NÃO prova que um executor, API ou agente consultou esta superfície e recebeu
// autorização antes de anexar um evento — o caminho executor→autorização→append
// não existe nem foi testado. Autoridade DECLARATIVA, não enforcement no executor.

// #VerifierGovernanceAction — vocabulário Mesh-local de AÇÕES do domínio.
// Forma IMPERATIVA deliberada (autorizar-fazer), morfologicamente distinta da
// forma de FATO dos event types adotados (verifier-registered, ...): a distinção
// torna visível qualquer confusão entre ação e evento.
#VerifierGovernanceAction:
	"register-verifier" |
	"deprecate-verifier" |
	"revoke-verifier" |
	"grant-verifier-authority" |
	"revoke-verifier-grant"

// #VerifierGovernanceDecisionClass — toda mutação do trust root é ato de
// DECISÃO. Não existe tier "propose" neste domínio: propor uma mutação de trust
// root sem decidi-la não é um estado governado que o sistema reconheça.
#VerifierGovernanceDecisionClass: "decide"

// #VerifierGovernanceAuthorityEntry — quem pode AUTORIZAR uma ação do domínio.
#VerifierGovernanceAuthorityEntry: {
	action!: #VerifierGovernanceAction

	// authorizedBy é a lista LITERAL ["founder"] por construção (adr-187 item 2,
	// founder-held). Ampliar a autoridade exige editar este tipo — ou seja, ato
	// de ADR, nunca digitação numa instância.
	authorizedBy!: ["founder"]

	decisionClass!: #VerifierGovernanceDecisionClass

	// resultingEventType — o FATO que a ação, quando executada, faz ser anexado
	// ao Registry. Declarado para tornar auditável a correspondência entre
	// caminhos de mutação e ações; NÃO é a autorização em si.
	resultingEventType!: string & !=""

	// FAIL-CLOSED contra o vocabulário ADOTADO: projeta .event da união
	// #VerifierRegistryEvent. Um resultingEventType fora da união adotada é
	// rejeitado por cue vet (testado). Fecha o sentido declarado ⊆ adotado; o
	// sentido inverso (adotado ⊆ declarado) é fechado pelo gate de cobertura.
	_validEventType: (as.#VerifierRegistryEvent & {event: resultingEventType}).event

	rationale!: string & !=""
}

// Instância singleton. Invariantes estruturais (bitem em cue vet, testados):
//  - autoridade não-duplicada: cada AÇÃO aparece no máximo uma vez;
//  - caminho não-ambíguo: cada EVENTO tem no máximo uma ação autorizante.
verifierGovernanceAuthority: {
	entries!: [...#VerifierGovernanceAuthorityEntry] & list.MinItems(1)

	_actions: [for e in entries {e.action}]
	_uniqueActions: true & (len(_actions) == len({for e in entries {"\(e.action)": true}}))

	_events: [for e in entries {e.resultingEventType}]
	_uniqueEvents: true & (len(_events) == len({for e in entries {"\(e.resultingEventType)": true}}))
}

verifierGovernanceAuthority: entries: [{
	action:             "register-verifier"
	authorizedBy:       ["founder"]
	decisionClass:      "decide"
	resultingEventType: "verifier-registered"
	rationale:          "Introduzir uma identidade nova no trust root cria a base de toda prova futura que a cite — quem entra é decisão estratégica, não operacional."
}, {
	action:             "deprecate-verifier"
	authorizedBy:       ["founder"]
	decisionClass:      "decide"
	resultingEventType: "verifier-deprecated"
	rationale:          "Sinalizar saída de uso altera o que a completion aceitará sem remover a identidade — julgamento de transição, não ato mecânico."
}, {
	action:             "revoke-verifier"
	authorizedBy:       ["founder"]
	decisionClass:      "decide"
	resultingEventType: "verifier-revoked"
	rationale:          "Revogação é terminal e irreversível pelo caminho canônico (não há evento de reativação); errar aqui obriga a registrar uma versão nova."
}, {
	action:             "grant-verifier-authority"
	authorizedBy:       ["founder"]
	decisionClass:      "decide"
	resultingEventType: "verifier-granted"
	rationale:          "Conceder autoridade é o ato que separa capability de authority — a distinção que impede um verifier capaz de adjudicar sem ter sido autorizado."
}, {
	action:             "revoke-verifier-grant"
	authorizedBy:       ["founder"]
	decisionClass:      "decide"
	resultingEventType: "verifier-grant-revoked"
	rationale:          "Grant-revoke é terminal por (versão, assertion schema): a presença histórica vence qualquer grant posterior — verificado que um re-grant fica INERTE na projeção e a invariante de grant-coverage então rejeita a versão não-revogada sem grant efetivo; reconceder exige versão nova."
}]
