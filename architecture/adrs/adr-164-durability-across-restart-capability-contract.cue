package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-164 — Durabilidade-através-de-restart é capability-contract obrigatória dos
// adapters PERSISTENTES do EventLogPort e do EvidencePort. Torna explícito o
// requisito tácito que o read-only de requisitos achou: o reference adapter in-memory
// dá durabilidade "de graça" (ou nem precisa) e os contract-tests atuais NÃO a exigem
// — um vendor não-durável passaria a suíte e quebraria o organismo persistente. Este
// ADR declara a CAPACIDADE (canônica); o kit + harness + regra de CI são prova no
// mesh-runtime (arco gated seguinte).

adr164: artifact_schemas.#ADR & {
	id:    "adr-164"
	title: "Durabilidade-através-de-restart é capability-contract obrigatória dos adapters persistentes (EventLogPort, EvidencePort)"
	date:  "2026-06-29"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		REQUISITO TÁCITO ENCONTRADO. O read-only de extração de requisitos (leitura dos
		contract-tests reais dos 2 Ports no mesh-runtime) achou que a durabilidade-através-de-
		restart é o BRINDE NÃO-CONTRATADO crítico. Os contract-tests atuais provam append-only,
		OCC, single-writer, ordenação intra-stream (EventLogPort) e content-addressability,
		fail-closed, imutabilidade, receipt (EvidencePort) — mas NENHUM prova que um evento ou
		conteúdo gravado sobrevive ao restart do processo. O reference adapter in-memory
		(adr-141 item 6: a spec executável e o oracle contra o qual Tier-1+2 passam) não tem
		durabilidade por design — o storage É a instância; restart = perda. Consequência: um
		vendor não-durável passaria toda a suíte atual e quebraria o organismo persistente.

		POR QUE AGORA. Fechar a lacuna é PRÉ-REQUISITO de qualquer escolha de vendor (def-041
		EventLogPort, def-045 EvidencePort): só com a durabilidade PROVADA a troca de vendor é
		CEGA — qualquer adapter que passe a suíte é durável de verdade, independente de qual.

		PRINCÍPIO DA SPEC RESPEITADO. A rationale do pm-cmt (contexts/cmt/port-manifest.cue)
		declara que propriedades GENÉRICAS do Port (ex.: dedup por eventId) pertencem à suíte de
		contract-tests do próprio Port no mesh-runtime, NÃO a obligation per-BC. Durabilidade é
		genérica → NÃO vira contractTestsRequired per-BC; é capability-contract declarada aqui e
		implementada no runtime.

		ALTERNATIVAS. (i) Deixar tácito (status quo) — rejeitada: é exatamente o brinde que
		quebra a troca cega. (ii) Obligation per-BC nos manifests — rejeitada: duplica um
		genérico entre BCs, contra o princípio acima. (iii) Adicionar um método "reopen" ao
		EventLogPort/EvidencePort — rejeitada: vazaria persistência no contrato domain-facing;
		durabilidade é capacidade de CONSTRUÇÃO do adapter, não método de Port.
		"""

	decision: """
		(a) REQUISITO. Todo adapter PERSISTENTE do EventLogPort e do EvidencePort DEVE provar
		durabilidade-através-de-restart por contract-test. Adapters de referência não-duráveis
		(o in-memory, adr-141 item 6) são ISENTOS por design.

		(b) FORMA DO TESTE. Gravar com uma instância; descartar a instância; abrir uma NOVA
		instância sobre o MESMO backing store; verificar que a leitura devolve o gravado.
		EventLogPort: readStream bit-idêntico, ordenação e versão preservadas. EvidencePort:
		retrieve devolve o conteúdo custodiado com content-address intacto. Isto descreve a
		CAPACIDADE observável a provar — não tecnologia: o kit que a prova e o harness de
		construção (abrir-sobre-handle) vivem no mesh-runtime (item f).

		(c) CATEGORIA SEPARADA, opt-in por binding. A durabilidade é um kit de contract-test
		PRÓPRIO (não o Tier-1 gerado, não a suíte Tier-2 do in-memory). Um adapter roda o kit se
		e somente se escreve o binding. O reference adapter in-memory NÃO binda → não-roda (não
		xfail): o teste é INEXPRIMÍVEL para ele (não há "mesmo storage entre instâncias"), e ele
		é o oracle de semântica, não-durável por contrato.

		(d) FRONTEIRA DE INTERFACE. O contrato domain-facing do Port NÃO muda — nenhum método
		"reopen" entra em EventLogPort/EvidencePort. A durabilidade exige só uma capacidade de
		CONSTRUÇÃO do adapter (abrir sobre um handle de storage durável), expressa no harness do
		kit de durabilidade, não no Port. O Port permanece cruzado apenas por value classes (P7).

		(e) ENFORCEMENT (princípio, não regra-de-string). Todo adapter PERSISTENTE deve bindar o
		kit de durabilidade; o reference adapter não-durável é ISENTO por design. O mesh-runtime
		implementa uma regra DETERMINÍSTICA que torna essa isenção legítima APENAS para adapters
		de referência DECLARADOS e PROIBIDA para vendors persistentes — assim nenhum vendor entra
		sem provar durabilidade (troca cega). A FORMA EXATA da distinção persistente-vs-referência
		(marcador POSITIVO de isenção, lista declarada, ou convenção) é decisão de IMPLEMENTAÇÃO
		do mesh-runtime, NÃO cravada neste ADR — inferir "persistente" por negação de nome é
		frágil, e um marcador positivo de isenção é mais honesto que exclusão por string; mas a
		escolha do mecanismo é do runtime. Este ADR fixa só o princípio: isenção legítima apenas
		para referência declarada; obrigatória para vendor persistente.

		(f) FRONTEIRA SPEC/RUNTIME. Este ADR declara a CAPACIDADE (canônica). O kit, o harness
		hook (abrir-sobre-handle-persistente) e a regra determinística de CI são IMPLEMENTAÇÃO no
		mesh-runtime — a prova — no arco gated seguinte (adr-148: capacidade é canônica no spec,
		tecnologia/implementação é runtime-local). Sem mudança de schema no mesh-spec
		(durabilidade não é obligation per-BC).

		ESCOPO. Aplica-se já a EventLogPort + EvidencePort (os 2 Ports com contract-tests vivos
		no mesh-runtime hoje). O princípio estende-se aos demais Ports PERSISTENTES/SoT
		(LedgerPort, WorkflowPort) quando materializarem. Ports de transporte PURAMENTE EFÊMEROS
		(entrega-e-esquece, sem estado a sobreviver ao restart) são isentos. NÃO se classifica o
		DeliveryPort aqui: o disco o caracteriza como "transporte durável, não-SoT" com invariante
		lease/ack/redelivery (adr-141 item 2 e item 6) — o que NÃO é puramente efêmero (uma
		mensagem não-ackada não pode sumir no restart); sua classificação fica para quando o
		DeliveryPort materializar (hoje não há interface/canon/contract-test dele, e nenhum
		manifest o consome).
		"""

	consequences: """
		POSITIVAS. A durabilidade deixa de ser brinde não-contratado e vira requisito PROVADO; a
		escolha de vendor (def-041/045) passa a ser troca cega (qualquer adapter que passe a
		suíte é durável). Zero poluição do contrato de Port. Princípio "genérico → suíte do Port,
		não per-BC" respeitado. O enforcement fica como princípio — o runtime escolhe a forma da
		distinção referência-vs-persistente sem o ADR cravar regra frágil.

		NEGATIVAS / JANELA. Entre este ADR e o pouso do kit + regra no mesh-runtime, o requisito
		está DECLARADO mas ainda não ENFORÇADO — fechado no arco gated imediatamente seguinte (os
		kits + CI rule), não deferido. Até lá, nenhum vendor persistente deve ser aceito. A carga
		do kit Tier-2-classe é hand-authored por Port (mesma natureza do N2 de adr-141).
		"""

	falsificationCondition: {
		condition:        "Esta decisão estará errada SE a durabilidade-através-de-restart não puder ser provada por teste determinístico reproduzível — p.ex. se o harness abrir-sobre-handle não simular restart fielmente (mantendo estado em memória entre as duas instâncias), dando falso-verde."
		observableSignal: "Um adapter persistente passa o kit de durabilidade mas perde dados em restart real (staging/prod); OU o kit não consegue ser bindado por nenhum adapter persistente real (harness inexpressável além do in-memory, indicando que a capacidade de construção exigida não foi modelada)."
	}

	affectedArtifacts: []

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: [
		"P7 — Port canônico cruzado só por value classes: durabilidade é capability do contrato de Port (não do vendor), provada por contract-test que todo adapter persistente satisfaz, sem alterar a superfície do Port.",
		"P10 — gate determinístico valida (não confiança): a durabilidade vira requisito PROVADO por teste determinístico reproduzível em vez de confiança na alegação do vendor.",
		"adr-141 — o reference adapter in-memory é o oracle dos contract-tests (item 6); este ADR estende o regime com a categoria de durabilidade que o in-memory não satisfaz por design.",
		"adr-148 — fronteira spec(capacidade)/runtime(implementação): o spec declara a capability; o mesh-runtime implementa o kit, o harness e a regra de CI.",
	]

	rationale: "Torna explícito e PROVADO o requisito tácito de durabilidade-através-de-restart — pré-requisito de troca de vendor cega (def-041/045) — declarando-o como capability-contract canônica sem poluir o contrato de Port nem duplicar genérico em obligation per-BC; o enforcement fica como princípio (forma da distinção referência-vs-persistente é decisão de implementação do runtime)."
}
