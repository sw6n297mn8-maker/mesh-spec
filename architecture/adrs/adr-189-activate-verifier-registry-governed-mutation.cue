package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr189: artifact_schemas.#ADR & {
	id:    "adr-189"
	title: "Ativar o Verifier Registry: mutação governada e regime causal (Slice C1)"
	date:  "2026-08-10"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "cross-artifact"

	context: """
		Estado precedente. adr-186 adotou o vocabulário de prova; adr-187
		estabeleceu o Verifier Registry (governance/build-time/verifier-registry.cue,
		seed events: []) e o domínio de autoridade verifier-governance (founder-held),
		declarados NÃO-OPERACIONAIS — os dentes temporais (append-only + causal) e o
		caminho governado de mutação foram explicitamente deferidos ao Slice C,
		"nascendo juntos". adr-188 estabeleceu #TaskSpecV2/#CompletionValidationV2/
		#TaskCompletionV2 como contrato, com a resolução de verifierRef para versão
		ativa/autorizada deferida ao Slice C. Duas investigações empíricas fundamentam
		este ADR. (a) #CommandType e #EffectClass (governance/build-time/
		work-governance.cue) são fechados sobre semântica de TAREFA — verificado por
		leitura: #CommandType é enum de 11 comandos de tarefa, e nenhum dos 6
		#EffectClass (admission, allocation, execution_signal, evidence_gated,
		destructive, topology_mutating) representa governança de trust root; forçá-los
		seria semanticamente falso. (b) o #VerifierRegistry adotado NÃO fecha a
		terminalidade causal — verificado por teste: grant-antes-de-register e
		re-register-após-revoke são rejeitados (invariantes R e U), MAS grant e
		deprecate APÓS revoked são ACEITOS, e um grant pós-revoke reentra em
		effectiveGrantKeys enquanto lifecycle permanece "revoked" (um revogado com
		grant "efetivo" coexistindo).

		Trigger. C1 deve tornar a governança/mutação do Registry OPERACIONAL para que
		C2 (resolução de verifier) e C3 (admission born-reject) tenham um trust root
		real contra o qual resolver e um caminho governado para populá-lo. Isso exige
		três coisas que hoje não existem: uma superfície de autorização de mutação
		distinta dos eventos persistidos; enforcement append-only (Git-prefix); e um
		gate de quiescência terminal que feche o gap causal (b) — pois o schema
		adotado sozinho não fecha. check-verifier-append-only.sh não existe em Mesh
		(verificado). Sem C1, o Registry permanece um seed sem caminho de mutação
		seguro e sem garantia causal, e V2 permanece não-operacional.
		"""

	decision: """
		(1) SUPERFÍCIE DE AUTORIDADE SEPARADA para a mutação de verifier-governance.
		Uma superfície Mesh-local declara a autoridade governada de mutação do domínio
		verifier-governance (founder-held, per adr-187 #AuthorityDomain), keyed pelas
		AÇÕES de verifier-governance. É distinta de — e não pode ser conflacionada com
		— o command-rights.cue de tarefa (keyed por #CommandType) nem com os fatos
		#VerifierRegistryEvent persistidos. A morada semântica é o domínio
		governance/build-time/; a shape e o arquivo concreto nascem no ciclo de
		implementação (podem exigir schema + instance separados — o ADR não promete
		um único arquivo).

		(2) AUTORIZAÇÃO DE MUTAÇÃO ≠ EVENTO PERSISTIDO. A superfície governa a DECISÃO
		de mutar (quem pode causar uma mutação, sob qual decision-class); o Registry
		armazena o FATO ocorrido. Um evento já-ocorrido nunca é autorização para
		fazê-lo ocorrer. Se um vocabulário de ação explícito for necessário, ele é
		criado no binding Mesh — não se reusa os event types adotados como se fossem
		comandos.

		(3) APPEND-ONLY via GIT-PREFIX. Um gate CI Mesh-local, blocking, compara o
		stream de eventos de BASE com o CANDIDATO e exige que a base seja prefixo
		EXATO — história anterior não pode ser reescrita/reordenada/apagada. É o dente
		temporal que adr-187 nomeou (equivalente ao check-verifier-append-only do
		Tekton). Distinção linguística deliberada: o Git-prefix compara base×candidato;
		os checks estruturais/causais (invariantes CUE + quiescência terminal) validam
		o stream candidato INTEGRAL. A propriedade "stream inteiro válido" pertence à
		composição de gates, não ao prefix gate isolado.

		(4) QUIESCÊNCIA TERMINAL (Mesh-local; o dente causal ausente). Regra normativa:
		após um (verifier id, version) atingir "revoked", NENHUM evento subsequente
		dirigido a essa versão é válido. "deprecated" NÃO é terminal (ainda admite
		operações válidas de lifecycle, notadamente revoke); apenas "revoked" é
		terminal. Valida o stream candidato inteiro. Vive FORA do schema adotado
		verbatim (não edita verifier-types.cue). Não é structural-check declarativo (a
		propriedade é temporal sobre a história, fora dos kinds declarativos do
		runner) — é gate imperativo.

		(5) O ESTADO OPERACIONAL EMERGE DOS DENTES, não de flag declarativo. O Registry
		é operacionalmente governável quando os três gates estão no caminho
		OBRIGATÓRIO de CI/mutação, todos BLOCKING: Git-prefix append-only blocking +
		cue vet do Registry (U/R/C + projeção) blocking + quiescência terminal
		blocking. Sem campo operational=true e sem meta-gate/estado derivado novo só
		para afirmar que os gates existem — o regime é a presença conjunta dos gates
		no caminho obrigatório.

		(6) O REGISTRY PERMANECE events: [] (machine-first). C1 entrega o caminho
		governado de mutação e seu regime causal sem semear verifier produtivo algum.
		Fixtures isoladas exercitam streams candidatos sem contaminar o trust root
		canônico e devem provar, no mínimo: registro válido passa; grant após registro
		válido passa; grant antes de registro falha; reescrita/reordenação/remoção do
		prefixo histórico falha; qualquer evento dirigido à versão após "revoked"
		falha; "deprecated → revoked" continua válido. Os testes de resolução
		exact-ref ∧ active ∧ grant pertencem a C2, não a C1.

		(7) GAP DE TERMINALIDADE REGISTRADO como candidato de promoção upstream ao
		Tekton (o gap existe no schema adotado). NENHUMA ação em tekton-spec dentro de
		M-182: sinal ao founder, não trabalho upstream.

		(8) FRONTEIRA DOWNSTREAM DECLARADA (C1 não a materializa). C2 (sem ADR
		presumido) estende #TaskCompletionV2: um proofResult satisfaz um requirement
		somente se resolve para (id, version, revision) EXATO cuja projeção de
		lifecycle é "active" E existe grant efetivo compatível com o assertion schema
		exigido — effectiveGrantKeys sozinho não é autoridade. C3 (sem ADR presumido)
		é a catraca born-reject em gate SEPARADO de V1, exige #TaskSpecV2
		explicitamente, e reavalia def-083 objetivamente contra sua condição de
		closure. def-084 (adjudicador cross-repo) permanece FORA de M-182.
		"""

	consequences: """
		Positivas.
		P1 — Regime causal COMPLETO no trust root: Git-prefix (base×candidato) + cue
		vet (U/R/C+projeção) + quiescência terminal fecham o gap (b) — um revogado não
		pode mais readquirir grant "efetivo" via evento pós-revoke. Observável: os
		casos grant/deprecate-após-revoked que hoje PASSAM passam a FALHAR no gate.
		P2 — Domínios separados por construção: autoridade de verifier-governance em
		superfície própria; command-rights.cue de tarefa e work-governance V1
		intocados; nenhum #VerifierRegistryEvent vira capability. Observável:
		affectedArtifacts não inclui command-rights.cue nem work-governance.cue.
		P3 — Operacional emerge dos três gates blocking no caminho obrigatório, não de
		flag: declaração e realidade não divergem por construção. Observável: nenhum
		campo operational=true no repo.
		P4 — Fronteira C1/C2/C3 limpa e testável: fixtures de C1 provam APENAS
		mutação+causalidade; resolução exact-ref∧active∧grant é C2. Observável:
		fixtures de C1 não referenciam #TaskCompletionV2.
		P5 — Trust root não contaminado: Registry permanece events: [] (machine-first);
		a máquina é provada por fixtures isoladas.

		Negativas.
		N1 — Binding Mesh deliberadamente mais restritivo que o schema adotado:
		#VerifierRegistry aceita eventos pós-revoke que o regime Mesh rejeita. Isso
		cria uma diferença comportamental que precisa permanecer explícita e testada.
		Mitigação: a restrição é monotônica — Mesh nunca aceita por causa dela algo que
		o contrato adotado rejeita —, o leaf verbatim permanece intacto, e o gap é
		registrado como candidato de promoção upstream.
		N2 — Área de manutenção nova: superfície de autoridade + enforcement temporal +
		fixtures. Mitigado: é o mínimo para governança de trust root operacional com
		segurança causal.
		N3 — Estado intermediário: Registry operacionalmente governável, mas ainda sem
		verifier produtivo (events: []) — a máquina existe e é provada, mas o Registry
		só se torna útil no fluxo V2 com C2/C3 e o primeiro verifier real (downstream).
		Aceito: C1 torna segura e operacional a governança/mutação; a utilidade em
		completion é passo seguinte.
		"""

	falsificationCondition: {
		condition: """
			Esta decisão estará errada se o regime dos três dentes não fechar a
			segurança do trust root, ou se a separação authority≠comando-de-tarefa não
			se sustentar na materialização: i.e., se existir sequência de eventos
			aceita pelo caminho governado que deixe um (id,version) revogado com grant
			efetivo ou reescreva história; ou se a superfície de verifier-governance
			precisar, na prática, reusar #CommandType/#EffectClass de tarefa para
			expressar autorização.
			"""
		observableSignal: """
			Um stream candidato construível que passe pelos três gates mas exiba, na
			projeção, um (id,version) "revoked" com entrada em effectiveGrantKeys; ou
			uma reescrita/reordenação de prefixo aceita; ou a superfície de
			verifier-governance materializada tendo de referenciar #CommandType ou
			#EffectClass de tarefa para expressar a autorização de mutação.
			"""
	}

	affectedArtifacts: [
		"governance/build-time/verifier-registry.cue",
	]

	plannedOutputs: []

	derivedArtifacts: [
		"governance/readme/structure-index.cue",
	]

	principlesApplied: ["P0", "P10", "P12", "P14"]

	supersedes: []

	rationale: """
		P12 é central: governança é código — o regime causal do trust root vira gates
		de CI (Git-prefix + quiescência terminal), policy-as-code versionada e
		auditável; toda regra que importa é imposta automaticamente, não documentada.
		P10 reforça: são gates DETERMINÍSTICOS que validam a história do Registry —
		nada estocástico decide; o trust root é enforçado por gate. P14 governa a
		classificação e foi confirmado por teste empírico: as invariantes
		type-expressáveis (identidade/refs/projeção U/R/C) já vivem em cue vet; as que
		o tipo NÃO alcança sobre o schema adotado (prefixo git da história; quiescência
		sobre o stream) sobem para gate determinístico — o padrão adr-076 (quando CUE
		não expressa, o enforcement sobe para CI, não vira convenção). P0 fecha: a
		autoridade de mutação tem localização canônica própria (não duplica
		command-rights nem os eventos), o schema adotado não é editado (zero drift), e
		o estado operacional emerge dos gates (não duplicado num boolean que poderia
		divergir).

		Trade-offs. A separação authority≠event custa superfície nova em vez de reusar
		command-rights — aceito porque o reuso seria semanticamente falso (investigação
		a). Fechar a quiescência Mesh-local custa um binding mais restritivo que o
		adotado — aceito porque a restrição é monotônica e a alternativa (editar
		verbatim) seria drift. reversibility medium / blastRadius cross-artifact: o
		change confina-se ao domínio verifier-governance + enforcement; não entra no
		fluxo de admission/completion (isso é C2/C3), e o Registry permanece events: []
		sem dependência produtiva downstream.

		Contexto de implementação (convenções verificadas; staging A — este ADR não as
		materializa). A superfície de autoridade tem morada no domínio
		governance/build-time/ (onde vivem command-rights.cue, verifier-registry.cue,
		work-governance.cue). Gates de script têm home em scripts/ci/ (check-*.sh,
		materialization-freshness.sh); seus testes/fixtures em scripts/ci/tests/
		(test_<gate>.py). O wiring blocking segue a convenção de workflow dedicado por
		check (.github/workflows/, como deferred-trigger-check.yml e
		self-review-check.yml), não step em validate.yml. A composição física — número
		de scripts/checks/workflows e as shapes/arquivos concretos — é decidida no
		ciclo de implementação de C1 contra essas convenções; o ADR fixa apenas que os
		dois dentes são blocking no caminho obrigatório, a superfície é separada, e as
		fixtures adversariais são obrigatórias. Por isso plannedOutputs é vazio neste
		ADR: só affectedArtifacts (verifier-registry.cue, cujo header do regime
		inaugural é atualizado quando os dentes ativam) e derivedArtifacts
		(structure-index) são paths concretos já decididos.
		"""
}
