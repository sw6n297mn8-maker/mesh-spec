package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-141 — Runtime kernel spec-side: Ports, manifests, reference adapters.
// Decisao estrutural completa (context/decision/consequences/rationale + falsificationCondition).
// Vendor-of-record por Port deferido a def-041..045 (arco subsequente, mesmo commit).
// Governanca de manifest (ArtifactTypes + structural-checks) deferida a adr-144.

adr141: artifact_schemas.#ADR & {
	id:    "adr-141"
	title: "Runtime kernel spec-side com Ports, manifests e adapters de referência"

	date: "2026-06-04"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		Segundo keystone da stack spec-side (W005/W006), na sequência adr-138 (runtime bootstrap) -> adr-139 (filtro spec x runtime, keystone-first) -> adr-140 (CUE como SoT, codegen, ContractGate). adr-140 fixou COMO a spec gera artefatos; falta definir A FRONTEIRA que o codigo gerado cruza para alcancar o runtime.

		Gap concreto: como o codigo gerado a partir da spec se conecta ao runtime sem vazar vendor SDK, primitives soltas, ou logica operacional para dentro do dominio. Sem uma fronteira canonica explicita, cada bounded context (BC) acoplaria a infraestrutura concreta, matando reversibilidade (P2) e tornando o codegen impuro (P1).

		Esta decisao materializa o P7 concreto (5 Ports canonicos retornando PortResult<T>, value classes na fronteira, module boundary) e a topologia LOGICA de containers (BC -> modulo), absorvendo o escopo de WI-087. Nao escolhe vendor, deploy, banco, fila, framework ou runtime fisico: define o contrato que o runtime deve implementar. A selecao de vendor por Port e deferida (def-041..045) e materializada JIT pos golden-example.

		Alternativas avaliadas: (a) Kernel baseado em Ports explicitos, com dominio gerado dependendo apenas de Port contracts, value classes, PortResult<T> e manifests, e vendors atras de adapters no runtime -- ESCOLHIDA: unica que preserva P2/P7 e mantem o golden-example CMT possivel com adapter-stub; (b) Runtime direto por vendor SDK, com codigo gerado chamando SDKs concretos de ledger/event log/workflow/broker/evidence -- rejeitada: viola P2 (vendor SDK entra no dominio), mata reversibilidade e torna o codegen impuro; (c) Kernel minimo sem manifests, gerando apenas interfaces de Port soltas -- rejeitada: perde governanca deterministica (agentes/runtime nao conseguem saber quais Ports um aggregate requer, quais stubs/adapters precisam existir, nem quais contract-tests aplicar); (d) Decidir vendor-of-record junto com os Ports -- rejeitada: mistura contrato spec-side com implementacao runtime; vendor por Port pertence a def-041..045.
		"""

	decision: """
		(1) DOMINIO ZERO-VENDOR. Nenhum codigo de dominio gerado depende de vendor SDK, banco, fila, workflow engine ou infraestrutura concreta. Toda dependencia operacional do dominio atravessa um Port canonico. Adapters de vendor vivem apenas em platform/adapters/, atras dos Ports (P2).

		(2) CINCO PORTS CANONICOS + PortResult<T>. O runtime expoe exatamente 5 Ports: EventLogPort (SoT dos fatos), LedgerPort (SoT do valor), WorkflowPort (SoT da execucao), DeliveryPort (transporte duravel, nao-SoT), EvidencePort (cadeia de custodia). Todo metodo de Port retorna PortResult<T> (sum type Ok/Err) -- nunca exception solta nem status primitivo. Adicao de metodo ou novo Port exige ADR (P7).

		(3) VALUE CLASSES NA FRONTEIRA. IDs, dinheiro, hashes, timestamps, escopos e referencias que cruzam a fronteira de Port usam value classes -- zero raw String/Long/Decimal. ESCOPO da regra: governa a superficie de operacao (nome do metodo, tipos-canon de entrada ordenados, tipo-canon de saida, taxonomia de erro, envelope PortResult). Features do sistema de tipos Kotlin (suspend, variance out T, nullability) sao interface-local, hand-authored-trusted, fora do alcance do check de conformidade (P7).

		(4) L3 -- PortManifest CUE E A SoT DA SUPERFICIE DO PORT; INTERFACE KOTLIN E PROJECAO VERIFICADA. A localizacao canonica da superficie de cada Port (operacoes, inputs, outputs, taxonomia de erro, envelope PortResult, value classes, obrigacoes de contract-test, requisito de reference adapter) e um PortManifest em CUE. A interface Kotlin nao e SoT: e projecao legivel/ergonomica hand-authored, autorizada somente enquanto um structural-check provar conformidade manifest <-> interface. Se interface e manifest divergirem, o manifest vence. Isto reconcilia P0 (localizacao canonica unica) com P1 (gerado da spec): tipos, validadores, stubs, tests e a verificacao da interface derivam do manifest; a interface Kotlin e projecao, nao fonte. Rejeitou-se gerar as 5 interfaces Kotlin de CUE agora (custo prematuro: superficie pequena e ADR-gated, churn ~zero) e rejeitou-se excecao verbal pura a P1 (fragil em self-review). O mecanismo do check e emissor-diff reusando a maquina CUE de def-040, nao KSP.

		(5) DOIS MANIFESTS COM CONTEUDO MINIMO. PortManifest declara: Ports consumidos, operations necessarias, adapters/stubs exigidos para o golden-example, contract-tests obrigatorios, requisito de reference adapter. AggregateManifest declara: aggregate name/id, commands aceitos, events emitidos, invariants/assertions relevantes, Ports requeridos, generated artifacts esperados. Conformidade do AggregateManifest: portsRequired e subconjunto dos 5 Ports; commands/events sao subconjunto do canon (canon/command, canon/event); o aggregate base gerado deriva do AggregateManifest. PortManifest e AggregateManifest SERAO ArtifactTypes governados -- a materializacao formal desses tipos (schema, production-guide, extensao do enum #ArtifactType, structural-check de cobertura) pertence ao adr-144 (e ao work item futuro de seu arco), FORA deste pacote.

		(6) CONTRACT-TESTS EM DOIS TIERS + REFERENCE ADAPTER. Port contract-tests existem como contrato deterministico em dois tiers. Tier 1 (gerado): derivado das obrigacoes do manifest + taxonomia de erro, governado pelo mecanismo de def-049 (assertion-to-test) para que testes derivados de assertion e Port contract-tests convirjam num unico mecanismo de derivacao -- cobre error-code coverage, conformidade PortResult/no-exception, boundary de value-class. Tier 2 (hand-authored, comportamental): invariantes temporais/comportamentais que schema nao captura -- optimistic concurrency no EventLogPort, atomicidade all-or-nothing do batch double-entry no LedgerPort, lease/ack/redelivery no DeliveryPort, content-addressability + receipt no EvidencePort, durable execution no WorkflowPort. Cada Port tem um reference adapter in-memory hand-authored, vendor-agnostico: e a spec executavel da semantica do Port, o stub para o golden-example, e o oracle contra o qual Tier 1+2 devem passar antes de qualquer adapter vendor. A obrigacao do reference adapter e declarada no manifest (in-spec); a implementacao vive em mesh-runtime (fora dos plannedOutputs deste pacote).

		(7) VENDOR-OF-RECORD DEFERIDO. A selecao de vendor por Port e deferida e materializada JIT: def-041 (EventLogPort), def-042 (LedgerPort), def-043 (WorkflowPort), def-044 (DeliveryPort), def-045 (EvidencePort). O Port abstrato e o mecanismo de saida (swap de adapter atras do mesmo Port, mesmos contract-tests); exits concretos por vendor vivem nos respectivos def.

		(8) TOPOLOGIA LOGICA DERIVADA + GOVERNANCA DE MANIFEST DEFERIDA AO adr-144. A topologia LOGICA de containers deriva do kernel: BC -> modulo gerado/runtime; Ports -> fronteira; adapters -> runtime. A topologia FISICA/deploy permanece deferida (def-038). Como consequencia necessaria desta decisao, dois structural-checks sao OBRIGATORIOS mas dependem dos ArtifactTypes de manifest: sc-port-manifest-conformance (conformidade manifest <-> interface Kotlin) e sc-manifest-coverage (todo BC-que-consome-Port tem PortManifest; todo aggregate tem AggregateManifest). Ambos sao materializados no arco do adr-144 (e do work item futuro de seu arco), junto com os ArtifactTypes de que dependem -- nunca neste pacote, sob pena de violar a cascata sc-pg-01 (check de cobertura de ArtifactType so existe depois do ArtifactType).
		"""

	consequences: """
		Positivas: (P1) Reversibilidade preservada -- trocar vendor e swap de adapter atras do mesmo Port, com os mesmos contract-tests; nenhuma mudanca no contrato de dominio. (P2) Golden-example CMT viavel sem vendor -- o reference adapter in-memory serve de stub, desacoplando o golden-example da selecao de vendor (def-041..045). (P3) Governanca deterministica -- o PortManifest/AggregateManifest tornam explicito e maquinalmente verificavel quais Ports um aggregate requer, quais stubs/adapters precisam existir e quais contract-tests aplicar; agentes nao inferem, leem o manifest. (P4) Codegen puro -- dominio depende so de Port contracts + value classes + manifests; zero vendor SDK no dominio mantem P1/P2. (P5) Convergencia de teste -- Tier 1 reusa o mecanismo de def-049, evitando um segundo mecanismo de derivacao de teste paralelo.

		Negativas / limitacoes: (N1) O check de conformidade manifest <-> interface exige um emissor de assinatura canonica (emissor-diff) como oracle -- custo nao-trivial (~30% do esforco de gerar as interfaces Kotlin), assumido conscientemente como preco de L3 para nao manter interfaces geradas como artefato vivo. (N2) Tier 2 (contract-tests comportamentais) e hand-authored, nao gerado -- carga manual recorrente por Port (concurrency, atomicidade, lease/ack, content-addressability, durable execution). (N3) Janela de governanca incompleta -- os structural-checks sc-port-manifest-conformance e sc-manifest-coverage sao obrigatorios mas so existem apos o adr-144 (e o work item futuro de seu arco) criar os ArtifactTypes de que dependem; ate la, a conformidade/cobertura de manifest nao e enforcada por gate, apenas por self-review + founder review. (N4) Reference adapter e trabalho runtime adicional por Port (5 implementacoes in-memory), pre-requisito para o golden-example.

		Follow-up obrigatorio (nao-output deste pacote): adr-144 (e o work item futuro de seu arco) materializam PortManifest/AggregateManifest como ArtifactTypes governados (schema em artifact-schemas/, production-guide, extensao do enum #ArtifactType em quality-criteria, e os structural-checks sc-port-manifest-conformance + sc-manifest-coverage). Esse work item futuro dependera de WI-103. Sem esse arco, N3 permanece aberta.

		(N5) CONDICAO DE MIGRACAO proposed->accepted (registrada 2026-06-11): a falsificationCondition nao disparou no run-001 do golden-example (CONTINUAR; zero vendor SDK; value classes na fronteira; reference adapter substituivel), mas a superficie exercitada foi 1 de 5 Ports e o gate do item 4 (conformance manifest<->interface, def-050) nao esta materializado. Migra a accepted quando: (a) >=2 Ports exercitados por contract-tests reais (Tier-1/2) -- provando que o padrao replica alem do EventLogPort; OU (b) def-050 materializado E o conformance check verde sobre >=1 par manifest<->interface. Verificavel por contagem de Ports com contract-tests no mesh-runtime + presenca/output do check.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			Esta decisao estara errada se o golden-example CMT exigir dependencia direta de vendor SDK,
			raw/primitive types na fronteira de Port, edicao semantica manual de codigo gerado, ou um
			adapter que nao possa ser substituido sem alterar o contrato de dominio -- qualquer um desses
			indica que a fronteira de Port nao e o mecanismo de isolamento suficiente e o kernel precisa
			ser repensado.
			"""
		observableSignal: """
			WI-137 / golden-example harness falha porque o codigo gerado precisa importar SDK de vendor, alterar
			manualmente contratos gerados, passar raw String/Long/Money pela fronteira do Port, ou acoplar
			um aggregate a um adapter concreto -- ou o reference adapter in-memory nao consegue satisfazer
			a suite de contract-test sem vazar detalhe de vendor.
			"""
	}

	affectedArtifacts: []

	plannedOutputs: [
		"architecture/deferred-decisions/def-041-eventlogport-vendor.cue",
		"architecture/deferred-decisions/def-042-ledgerport-vendor.cue",
		"architecture/deferred-decisions/def-043-workflowport-vendor.cue",
		"architecture/deferred-decisions/def-044-deliveryport-vendor.cue",
		"architecture/deferred-decisions/def-045-evidenceport-vendor.cue",
		"architecture/tension-log/ten-015-port-interface-handauthored-vs-p1.cue",
	]

	defersTo: ["def-041", "def-042", "def-043", "def-044", "def-045"]

	principlesApplied: ["P0", "P1", "P2", "P7", "P10", "P13"]

	supersedes: []

	rationale: """
		A alternativa (a) e a unica que preserva P0, P2 e P7 sem comprometer o golden-example, ao custo de ESTREITAR P1 conscientemente. A tensao central -- P1 exige codigo gerado, nunca escrito a mao, para tipos/validadores/stubs/projetores, mas as 5 interfaces de Port sao ADR-gated e de churn ~zero, tornando a geracao de interface custo prematuro -- e tratada por L3: o PortManifest CUE e a localizacao canonica unica (P0) e a fonte de derivacao P1-conformante (tipos, validadores, stubs, tests, verificacao da interface); a interface Kotlin e projecao hand-authored, autorizada SOMENTE enquanto sc-port-manifest-conformance provar conformidade manifest<->interface. Isto e um estreitamento consciente de P1 (interface hand-authored, nao gerada), nao satisfacao limpa [TENSAO: ten-015 vs P1] -- registrado em ten-015 e mitigado pelo gate de conformidade (a interface nao pode divergir do manifest canonico).

		P2 e P7 sao materializados diretamente: vendor so atras de adapter (P2); 5 Ports retornando PortResult<T> com value classes na fronteira (P7). P10 ancora o modelo de enforcement: os structural-checks sc-port-manifest-conformance e sc-manifest-coverage sao gates deterministicos -- agentes estocasticos recomendam o preenchimento de manifest, mas o check valida; nada de manifest entra como conforme sem passar o gate (materializado no adr-144). P13 governa a topologia: a decomposicao BC -> modulo e decisao de design explicita e auditavel derivada do kernel, nunca emergente -- cada BC mapeia a um modulo logico com fronteira de Port explicita, e a dependencia runtime e visivel, nao implicita.

		A reversibilidade media com blast-radius repo-wide e coerente: o kernel orienta todos os BCs e generated artifacts (repo-wide), mas e reversivel via swap de adapter atras do Port sem alterar o contrato de dominio (medium). medium e calibracao AGREGADA de duas dimensoes: vendor-of-record tem reversibilidade ALTA (swap de adapter atras do mesmo Port, mesmos contract-tests), mas a forma do kernel (contagem/identidade dos 5 Ports, envelope PortResult<T>, regra de value-class) tem reversibilidade BAIXA (exige ADR) -- medium e a media honesta. Vendor-of-record e deferido (def-041..045) porque escolher vendor agora misturaria contrato spec-side com implementacao runtime, violando o filtro de adr-139.
		"""
}
