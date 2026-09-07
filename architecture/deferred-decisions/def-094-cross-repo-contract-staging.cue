package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def094: artifact_schemas.#DeferredDecision & {
	id:     "def-094"
	title:  "Staging de mudança de contrato cross-repo — os gates mútuos do spec e do runtime se travam"
	date:   "2026-09-07"
	status: "open"

	description: """
		Os dois gates cross-repo leem a DEFAULT BRANCH um do outro, e por
		isso uma mudança de contrato que atravessa os dois repos trava os
		dois de uma vez. Diagnóstico MEDIDO na travessia do adr-198 (não
		inferido — a mecânica foi lida no código dos gates depois de duas
		deduções erradas sobre a ordem de merge):

		(1) mesh-spec `codegen-validation` (.github/workflows/
		codegen-validation.yml → scripts/ci/validate-codegen.sh →
		`mesh-codegen pipeline`): o pipeline monta o scratch copiando as
		slices HAND-AUTHORED de MESH_RUNTIME_DIR — um checkout SEM `ref:`
		do mesh-runtime, isto é, a `main` — e só então gera fresco a
		partir da árvore do spec sob avaliação; o passo [2/5] compila os
		dois juntos. Um PR do spec que muda contrato compila tipos
		gerados NOVOS contra slices que ainda não foram atualizadas.

		(2) mesh-runtime `regenerate-check` (FF-CG-03, scripts/
		regenerate.sh --check): regenera a partir de um checkout SEM
		`ref:` do mesh-spec (= `main`) e diffa contra o baseline
		commitado. Um PR do runtime que carrega o baseline NOVO o compara
		com o contrato VELHO.

		Nenhum dos dois é consertável dentro do próprio repo: deixar
		qualquer um verde no lugar significa reverter a mudança que ele
		carrega. Fica DEFERIDO o mecanismo de staging cross-repo — não a
		escolha entre suas formas possíveis.
		"""

	deferralRationale: """
		MOTIVO de deferir agora: o desenho de um mecanismo de staging
		(override de ref, protocolo de PR pareado, aterrissagem em duas
		fases, ou outro) exige mais de UMA instância da qual generalizar.
		A travessia do adr-198 é a primeira observada; desenhar o
		protocolo a partir dela cravaria a forma de um caso particular
		como lei de um problema estrutural. Custo evitado: protocolo
		cross-repo desenhado sobre n=1.

		Custo de continuar deferindo: TODA mudança de contrato que
		atravessa os dois repos reencontra o ciclo, e a saída é sempre
		um merge com gate reconhecidamente vermelho. O risco não é o
		vermelho em si — é o hábito. Gate que se contorna por julgamento
		recorrente deixa de ser gate e vira sugestão; o P10 (agentes
		recomendam, gates determinísticos validam) depende de o gate
		nunca ser negociável.

		PRECEDENTE ESTABELECIDO NESTA TRAVESSIA, para a próxima
		reencontrar: mergeia primeiro o lado que está CUMPRINDO a
		obrigação (o runtime), não o que a está IMPONDO (o spec). A
		regra 'o spec não mergeia à frente do que ele obriga' protege
		contra contrato publicado que a implementação não satisfaz; o
		runtime entrando primeiro INVERTE essa exposição — ele entra
		honrando uma obrigação que está a um merge de existir, e a
		janela vermelha pertence ao spec ainda não publicado, não a
		implementação faltante. Desempate secundário, se o primeiro não
		bastar: o gate spec-INDEPENDENTE do runtime (build-test) estava
		verde — veredito honesto sobre o código em si, que o
		regenerate-check vermelho não contradiz (ele afirma que o spec
		está atrasado, não que o runtime está errado).

		A PREVISÃO ERA FALSIFICÁVEL, e é isso que separa este registro
		de uma opinião. A hipótese: o vermelho do codegen-validation do
		#257 se dissolveria assim que as slices chegassem à main do
		runtime, e falharia no passo [2/5] até lá. Se ele tivesse
		continuado vermelho depois do merge do mesh-runtime #50, o
		diagnóstico estaria errado e este precedente não valeria. Ele
		passou exatamente no ponto previsto — mesma qualidade de prova
		que a falsificação do adr-177 teve ao disparar por direção não
		antecipada.

		JANELA VERMELHA MEDIDA nesta travessia: 2 minutos e 42 segundos
		(mesh-runtime `54333422` em 2026-09-06T20:08:32-03:00 → mesh-spec
		`3706938` em 2026-09-06T20:11:14-03:00), com o re-run do
		regenerate-check na main do runtime confirmando verde em seguida.
		O número é o PONTO DE COMPARAÇÃO: o precedente é aceitável
		porque a janela é curta e fecha sozinha. Se numa próxima
		travessia ela durar horas ou dias, o precedente precisa ser
		reexaminado — sem o número medido, a sessão seguinte teria só o
		raciocínio.

		RECUSADO NO ATO, registrado para não se perder: dar override de
		`ref:` a um dos gates para que leia a branch do PR irmão.
		Recusa, não pendência — mudar a semântica de um gate para
		resolver um caso é o começo do gate que não diz mais não. Se o
		mecanismo de staging vier a incluir leitura de branch, ela nasce
		como protocolo desenhado, não como contorno de um caso.
		"""

	triggerCalibrationRationale: """
		manual-review + temporal, deliberadamente sem predicado de
		conteúdo. O sinal real — 'a segunda mudança de contrato que
		atravessa os dois repos' — não é observável na estrutura de
		nenhum artefato do spec: ele se manifesta como um par de PRs
		vermelhos em dois repositórios, e o runner não enxerga o CI nem
		o outro repo. Um predicado sobre os workflows (procurar `ref:`
		aparecendo em codegen-validation.yml) cravaria a grafia de UMA
		das soluções possíveis como gatilho — exatamente a que foi
		recusada. O temporal de 90 dias existe para que o adiamento não
		fique invisível: sem ele, um problema cujo sintoma só aparece
		durante uma travessia some do radar entre travessias.
		"""

	originatingArtifacts: [
		"architecture/adrs/adr-198-quotation-item-primitive-and-line-level-gate.cue",
		"architecture/adrs/adr-148-mesh-runtime-bootstrap-handoff.cue",
		"governance/build-time/codegen-contract.cue",
	]

	costOfDeferral: {
		severity:    "medium"
		blastRadius: "cross-cutting"
		description: """
			medium porque o ciclo é contornável a cada travessia por um
			merge ordenado — o dano não é bloqueio, é erosão: cada contorno
			normaliza o gate negociável, e a conta chega quando alguém
			contorna um vermelho que NÃO era o desta natureza.
			cross-cutting porque atinge os dois repos e toda mudança de
			contrato que os atravessa, não um artefato ou um BC. Exit: o
			mecanismo de staging desenhado sobre >= 2 travessias
			observadas, com a janela vermelha medida de cada uma.
			"""
	}

	triggers: [{
		kind:   "manual-review"
		reason: "O sinal — a segunda travessia de contrato cross-repo — só se manifesta como par de PRs vermelhos em dois repositórios; o runner não lê CI nem o outro repo, e um predicado sobre os workflows cravaria a grafia da solução recusada como gatilho."
	}, {
		kind:       "temporal"
		maxAgeDays: 90
	}]
}
