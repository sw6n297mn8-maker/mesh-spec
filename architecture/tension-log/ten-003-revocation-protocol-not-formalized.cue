package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten003: artifact_schemas.#TensionEntry & {
	id:    "ten-003"
	date:  "2026-04-07"
	title: "Protocolo de revogação de identidade não formalizado bloqueia gate determinístico de IDC"

	kind:          "cross-artifact-friction"
	tensionTarget: "P10"
	manifestsIn:   "contexts/idc/canvas.cue"

	description: """
		Classificação operacional: dependência de segurança ainda
		não resolvida — não fricção temporária aceitável. Afeta
		diretamente a cadeia de confiança da Mesh: enquanto a
		invariante (2) do gate determinístico de sign-evidence
		não for verificável, há janela em que IDC pode emitir
		assinaturas sobre evidência cuja identidade subjacente
		já não é vigente. O schema #TensionStatus atual não
		distingue criticidade — esta classificação é registrada
		aqui em linguagem explícita para visibilidade. Status
		"accepted" sinaliza apenas que o trade-off operacional
		é tolerável no curto prazo, não que a tensão seja
		arquiteturalmente benigna.

		O canvas IDC declara como autonomousDecision a operação
		sign-evidence, justificada por gate determinístico de
		quatro invariantes pré-assinatura. A invariante (2)
		exige que a identidade vinculada à evidência tenha
		"resultado vigente (não revogado)". Para ser
		determinística, esta invariante depende de um protocolo
		de revogação formalizado: como uma identidade verificada
		é marcada como revogada, como a revogação é propagada
		para consumers que cachearam o resultado anterior, e
		qual é o TTL ou mecanismo de invalidação ativa. Hoje
		esse protocolo não existe — está registrado como oq-idc-1
		no canvas. Enquanto não existir, a invariante (2) é
		declarativa, não verificável. P10 exige gates
		determinísticos sobre operações com impacto financeiro;
		assinatura DSSE participa do gate financeiro downstream
		(LOG → DLV → INV → FCE), portanto a completude do gate
		é condição para conformidade com P10.
		"""

	resolution: """
		Manter sign-evidence como autonomousDecision com gate
		declarado e registrar abertamente a tensão e a
		dependência externa. Alternativa rejeitada: mover
		sign-evidence para supervisedDecision até protocolo
		de revogação existir — rejeitada porque impor supervisão
		humana universal sobre operação criptográfica
		determinística degradaria throughput de toda a trust
		layer para cobrir um vetor cuja contenção provisória
		já é parcialmente feita por TTL, reconciliação periódica
		entre IDC e consumers, e bloqueio downstream em DLV/INV.
		Outra alternativa rejeitada: omitir a invariante (2)
		— rejeitada porque tornaria o gate manifestamente
		incompleto. Trade-off aceito: autonomia operacional
		sustentada com risco residual de janela entre revogação
		e propagação, mitigado pela contenção provisória descrita.
		"""

	status: "accepted"

	structuralResolutionPath: """
		Formalização do protocolo de revogação de identidade
		como artefato dedicado (provavelmente
		contexts/idc/revocation-protocol.cue ou seção de
		agent-spec.cue) com decisão explícita entre TTL passivo,
		invalidação ativa via evento, ou modelo híbrido.
		Resolução de oq-idc-1 é a porta de entrada estrutural.
		"""

	rationale: """
		Tensão registrada após validação semântica do canvas
		IDC identificar que o gate determinístico de
		sign-evidence depende de artefato ainda não
		materializado. Registro explícito é preferível a
		esconder a dependência no texto do canvas — agentes
		futuros e regulador podem reconstituir o estado real
		do gate.

		Esta tensão deve ser tratada como bloqueador para
		qualquer evolução estrutural que dependa do gate
		determinístico completo de sign-evidence (e.g.,
		remoção de gates humanos adicionais downstream,
		automação de fluxos consumindo EvidenceSigned, ou
		exposição de capacidade de assinatura a novos
		consumers).
		"""
}
