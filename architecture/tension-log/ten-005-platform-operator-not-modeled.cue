package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten005: artifact_schemas.#TensionEntry & {
	id:    "ten-005"
	date:  "2026-04-07"
	title: "Operador da plataforma não modelado como stakeholder distinto bloqueia análise adversarial completa em IDC"

	kind:          "cross-artifact-friction"
	tensionTarget: "domain/stakeholder-map.cue"
	manifestsIn:   "contexts/idc/canvas.cue"

	description: """
		Classificação operacional: dependência de segurança ainda
		não resolvida — não fricção temporária aceitável. IDC é
		raiz de confiança da Mesh; um adversário com papel de
		operador da plataforma é estruturalmente o vetor mais
		poderoso contra a cadeia de confiança, e a ausência de
		modelagem desse ator no stakeholder map impede que o
		canvas IDC declare contramedidas adversariais explícitas.
		O schema #TensionStatus não distingue criticidade — esta
		classificação é registrada em linguagem explícita.
		Status "accepted" reflete apenas que o trade-off é
		tolerável enquanto founder = operador, não que a lacuna
		seja arquiteturalmente benigna.

		O stakeholder map atual modela cinco atores
		(sh-01..sh-05): construtora, fornecedor, parceiro
		financeiro, Bacen, agente de IA. Não há entry distinta
		para "operador da plataforma" — entidade que opera a
		infraestrutura Mesh. Enquanto founder e operador são a
		mesma pessoa, a equivalência informal cobre o vetor.
		Quando essa equivalência deixar de valer (delegação a
		terceiro, escala que exige equipe operacional, ou
		separação societária), IDC precisa endereçar
		explicitamente o vetor de manipulação do operador
		sobre verificação de identidade e geração de proofs:
		favorecimento de próprios clientes, extração de
		inteligência sobre identidades verificadas, viés
		sistemático na calibração de threshold. A análise de
		incentivos do canvas IDC não cobre este vetor porque
		não há sh-NN para vincular. dp-08 (incentivos
		adversariais) só pode ser aplicado a atores modelados.
		"""

	resolution: """
		Manter o canvas IDC sem entry de incentivo para
		operador e registrar a lacuna como oq-idc-4 no canvas
		e como esta tensão no log sistêmico. Alternativa
		rejeitada: criar sh-06 unilateralmente no canvas IDC
		— rejeitada porque alteração no stakeholder map é
		decisão de domínio, não de BC, e exigiria reavaliação
		de todos os BCs que referenciam stakeholder map. Outra
		alternativa rejeitada: mapear o vetor para sh-05
		(agente) — rejeitada porque conflate dois atores
		distintos (executor automatizado vs. operador humano
		com acesso privilegiado), perdendo precisão analítica.
		Trade-off aceito: reconhecer que enquanto founder=operador,
		o vetor é coberto pela mesma supervisão humana, e que
		a promoção do operador a stakeholder será necessária
		antes da primeira delegação operacional.
		"""

	status: "accepted"

	structuralResolutionPath: """
		Adição de sh-06 (operador da plataforma) ao stakeholder
		map em domain/stakeholder-map.cue, com descrição, role,
		meshInteraction e concerns. Após criação, IDC e outros
		BCs sensíveis (REW, NPM, FCE) devem revisar suas seções
		de incentiveAnalysis para endereçar o vetor de operador
		onde aplicável. Decisão deve preceder qualquer movimento
		de delegação operacional do founder.
		"""

	rationale: """
		Tensão registrada porque a validação semântica do
		canvas IDC identificou o vetor de operador como
		ausência substantiva. Registrar como tensão (em vez
		de apenas open question) torna a lacuna parte do
		estado epistêmico sistêmico, não apenas do BC.
		Promove rastreabilidade quando for hora de evoluir
		o stakeholder map.

		Esta tensão deve ser tratada como bloqueador para
		qualquer movimento de delegação operacional do founder
		(contratação de equipe operacional, terceirização de
		operação de IDC, ou separação societária entre founder
		e operador). A modelagem de sh-06 deve preceder, não
		seguir, a primeira delegação.
		"""
}
