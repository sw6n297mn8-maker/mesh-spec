package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def058: artifact_schemas.#DeferredDecision & {
	id:     "def-058"
	title:  "EvidencePort verify para re-verificacao de integrity proofs de signals upstream (REW)"
	date:   "2026-06-12"
	status: "open"

	description: """
		O pm-rew (fatia REW, caminho da elegibilidade) decidiu NAO consumir EvidencePort nesta fatia. A
		integridade de signal que o recorte materializa e o idempotency split do evt-signal-received:
		(signalId, sourceContext) = identity, signalHash = integrity — comparacao deterministica de hash
		computada pelo proprio REW na ingestao. O vo-integrity-proof upstream e proofRef OPACO para storage do
		BC de origem, e o domain-model declara explicitamente que REW nao valida proof semanticamente
		('runtime usa proofRef para re-verificacao se necessario'). Fica deferida a decisao de COMO a
		re-verificacao semantica de proofs entra quando o fluxo consumidor materializar: (a) EvidencePort.verify
		(exigiria ponte entre proofRef upstream e EvidenceAddress/IntegrityProof da custodia Mesh — rtd-012);
		(b) ACL runtime propria do REW (verificacao fora da superficie de Port); (c) permanece delegada ao BC
		de origem (REW confia na interpretacao validada upstream, per bd-signal-as-interpretation); ou (d)
		outra forma que o fluxo real revelar.
		"""

	deferralRationale: """
		MOTIVO de deferir: o fluxo que CONSOME a falha de integridade (evt-signal-corruption-detected → alert
		critico → review humano) esta FORA do recorte da fatia (alerts/excecoes fora). Custo evitado: contrato
		fabricado — forcar verify(EvidenceAddress, IntegrityProof) sobre proofRef opaco upstream criaria
		operacao de Port sem fluxo consumidor na fatia E com type mismatch contra a superficie canonica
		(rtd-012: EvidenceAddress e CAS sha256 da custodia Mesh; proofRef e identifier de storage do BC de
		origem), alem de suite de contract-test sem objeto. Custo de continuar deferindo: re-verificacao
		semantica de proof fica runtime-deferred — aceitavel porque o mecanismo de integridade da ingestao que
		o domain-model CANONIZA (signalHash match, deteccao de mutacao upstream) esta integralmente coberto no
		recorte, e 'integridade != veracidade': a veracidade da interpretacao e responsabilidade do BC de
		origem, nao do REW.
		"""

	triggerCalibrationRationale: """
		Trigger unico manual-review: o gatilho real e a materializacao do fluxo de corruption/alerts nos
		schemas do REW (evt-signal-corruption-detected, evt-risk-alert-* ganhando payload contracts) — padrao
		de CONTEUDO dentro de arquivo que ja existira (contexts/rew/schemas/events.cue foi criado nesta mesma
		fatia), nao presenca de arquivo novo em path determinavel. file-exists nao discrimina o caso; condicao
		machine-evaluable por conteudo nao esta no vocabulario do runner. O founder reconhece o padrao em
		review do PR que materializar a fatia de alerts/excecoes do REW.
		"""

	originatingArtifacts: [
		"contexts/rew/port-manifest.cue",
		"contexts/rew/domain-model.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque nenhum fluxo da fatia e bloqueado: a integridade de ingestao canonizada pelo
			domain-model (idempotency split via signalHash) esta coberta; a re-verificacao semantica de proof e
			explicitamente runtime-deferred pelo proprio dm. cross-artifact porque a decisao incidira sobre
			pm-rew (superficie de Port) + mesh-runtime (adapter/ACL) + possivelmente a ponte com a custodia
			Mesh (EvidenceAddress). Exit: decidir (a)-(d) quando a fatia de alerts/excecoes materializar o
			fluxo consumidor.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O gatilho e a materializacao do fluxo de corruption/alerts nos schemas do REW — padrao de conteudo dentro de contexts/rew/schemas/events.cue (arquivo que JA existe desde esta fatia), nao presenca de arquivo novo em path fixo; file-exists nao discrimina e o vocabulario do runner nao avalia conteudo. Founder reconhece em review do PR da fatia de alerts/excecoes."
	}]
}
