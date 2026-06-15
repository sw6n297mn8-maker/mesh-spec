package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-151 -- Estabelece rastreabilidade semântica first-class entre a linguagem
// ubíqua (glossários de BC) e o domain-model, espelhando na camada de linguagem
// a maquinaria que a camada de schema já tem para conceitos compartilhados
// (#Money + família shared-types).
//
// Estrutura completa (identidade, classificação, context+alternativas, decision
// com D1/D2/non-goal, rastreabilidade, consequences N1-N4, falsificationCondition,
// rationale). status: proposed — a materialização (deltas de schema,
// glossário-kernel, gate de produção, backfill) é plannedOutput; promoção a
// accepted após materialização e validação, per o protocolo de lifecycle do repo.

adr151: artifact_schemas.#ADR & {
	id:    "adr-151"
	title: "Estabelecer rastreabilidade semântica first-class entre linguagem ubíqua e domain-model"

	date: "2026-06-15"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	reversibility: "medium"
	blastRadius:   "repo-wide"

	context: """
		(a) Estado. A Mesh já governa conceitos compartilhados na camada de
		schema, mas não na camada de linguagem ubíqua. No schema, o primitivo
		monetário tem lar canônico único (#Money em
		architecture/shared-schemas/money.cue) e uma família de governança de
		tipos compartilhados já instalada (adr-094 schematize-shared-types,
		adr-030 shared-classification, def-025 consolidação). A camada de
		linguagem — os glossários de cada BC — não tem equivalente: não há
		marcação de quais conceitos são de primeira classe, não há elo
		verificável do termo de glossário ao building block do domain-model, e
		não há sequer lar legal para um termo compartilhado
		(#Glossary.canonicalPathRegex proíbe glossário fora de
		contexts/<bc>/). A assimetria é o problema: a estrutura é governada; a
		linguagem que a nomeia, não.

		(b) Gatilho. A descoberta concreta foi que o conceito central do FCE —
		Payment (agg-payment) — não tinha termo na linguagem ubíqua, justamente
		no BC que é o último gate antes da primeira tela bancária (a aprovação
		humana sobre o PrePaymentGuard). A varredura sistêmica mostrou não ser
		caso isolado: a maioria dos BCs tem termos de glossário com
		domainModelRefs vazios — o elo linguagem→modelo está ausente repo-wide.
		Nota de sequenciamento: os rationales obsoletos que afirmavam falsamente
		a inexistência dos domain-models foram corrigidos ANTES deste ADR, em
		patch factual separado e já mergeado (PR #146), deliberadamente para não
		misturar reparo factual com decisão de política.

		(c) Evidência. A decisão não repousa em desenho abstrato, mas em três
		pilotos rodados contra o disco real, em branches descartáveis: (1) caso
		owned — marcação firstClass do FCE com gates G1–G5, provando que lacunas
		e falsos-positivos são pegos; (2) caso shared — Money cruzando
		inv/p2p/bdg/bkr, contrastando cobertura local vs canônica e estressando
		o falso-negativo do conceito órfão de definição; (3) caso lar-canônico —
		sete erros injetados (E1–E7) contra o enforcer real
		(scripts/ci/structural-check-runner.py), provando que a extensão mínima
		do canonicalPathRegex é necessária (órfão bloqueante antes) e suficiente
		(limpo depois) com zero regressão nos 12 glossários existentes.

		Status e maturidade. Este ADR entra como proposed, e proposed aqui não
		significa quase-completo: a decisão de design está tomada, mas a
		materialização está pendente. O gate de produção, os deltas de schema
		(#Glossary e os campos de domain-model), o glossário-kernel
		compartilhado e o backfill dos elos são plannedOutputs — não evidência
		concluída. A promoção a accepted depende do protocolo de lifecycle do
		repositório, após materialização e validação; este ADR não a antecipa.

		Alternativas consideradas.
		1. Name-matching como fonte de verdade (igualdade aproximada entre
		   termEn e o nome do conceito governa a cobertura) — rejeitada:
		   heurística é governança aparente, não real. Não distingue um termo
		   dedicado de um quase-acerto que apenas pasta, e um gate determinístico
		   erguido sobre matching difuso dá falsa confiança. O piloto 1 mostrou
		   que só igualdade normalizada-exata serve — e, ainda assim, como
		   cobertura advisory, não como verdade semântica.
		2. Cobertura local para conceito compartilhado (cada BC define seu
		   próprio term-money) — rejeitada: satisfazê-la exige N cópias do mesmo
		   termo, uma por BC que usa Money — violação direta de P0 (localização
		   canônica única). Um gate que só se satisfaz violando P0 é
		   autodestrutivo (piloto 2).
		3. Co-localizar o termo compartilhado no arquivo de schema (money.cue) —
		   rejeitada por prova mecânica: arquivos de definição de tipo (com
		   #-def top-level) são pulados pelo classificador de órfão
		   (is_type_definition_file), então um termo ali escaparia inteiramente à
		   governança; além de misturar schema (#Money) com linguagem ubíqua,
		   violando a fronteira "o que NÃO vive aqui" do próprio #Glossary
		   (piloto 3).
		4. firstClass anotado + cobertura dedicada para conceito owned + termo
		   canônico compartilhado com lar legal (extensão mínima e controlada do
		   regex) — escolhida: a única leitura fechada-contra-evasão (o gate pega
		   órfão, vizinho-errado e duplicata), conforme a P0 (um termo canônico
		   mais ponteiros), e mecanicamente provada necessária, suficiente e sem
		   regressão contra o enforcer real.
		"""

	decision: """
		Esta decisão estabelece rastreabilidade semântica first-class entre a
		linguagem ubíqua e o domain-model, em seis partes, mais o contrato do
		gate, a ordem de materialização e um non-goal.

		1. Declaração explícita. Conceitos de primeira classe são declarados
		explicitamente no domain-model — firstClass: true|false mais
		firstClassReason tipado (enum positivo para true, negativo para false).
		Default proibido para quem cruza contrato: um conceito que aparece em
		port-manifest, assertion ou aggregate-manifest e não está marcado é erro
		de gate (G2). A máquina não infere significado de negócio; o humano
		declara, a máquina verifica.

		2. Forma A (owned). Conceito owned por um BC exige firstClass:true +
		firstClassReason (enum positivo) + coreNoun (o substantivo canônico) +
		um termo de glossário dedicado cujo domainModelRefs aponta o conceito.
		Cobertura dedicada exige correspondência de nome via coreNoun: raspão,
		vizinho-errado e termo-genérico NÃO satisfazem (G1 cobertura-dedicada +
		G3 referência-existe-e-corresponde).

		3. Forma B (shared). Primitivo transversal entre BCs exige shared:true +
		canonicalSchemaRef (aponta o shared-schema, ex. #Money) +
		canonicalTermRef (aponta o termo no glossário-kernel). Duplicata local
		fingindo canônica é detectada (E7); shared:true sobrepõe o filtro de
		estrangeiro/sourceContext — um primitivo transversal nunca é isento como
		estrangeiro (fecha o falso-negativo 4f).

		4. Lar canônico. O #Glossary.canonicalPathRegex é estendido minimamente
		para admitir architecture/shared-schemas/glossary.cue como lar legal do
		termo compartilhado. Regex alvo:
		^(contexts/[a-z][a-z0-9-]*|architecture/shared-schemas)/glossary\\.cue$.
		Provado contra os 12 glossários existentes: zero regressão, zero
		ambiguidade nova (piloto 3, enforcer real).

		5. Rejeição forte da co-localização. Termos canônicos NÃO vivem dentro
		de arquivos de schema. Arquivos de definição de tipo são pulados pelo
		classificador de órfão, então um termo ali seria invisível à governança
		— rejeição por prova mecânica, não por preferência (piloto 3).

		6. Especialização local (Forma B.2). Deferida para deferred-decision
		própria (def-062). A regra de corte é formas distintas de narrowing, não
		número de cabeças: hoje n=1 de forma (apenas bkr/vo-settlement-value,
		narrowing de Money excluindo zero). A def-062 carrega dois gatilhos —
		massa (2ª forma distinta → revisita para ADR) e risco (1º masquerade
		detectado → revisita urgente) — e registra o caso conhecido (bkr).

		D1 — Contrato do gate. Esta decisão enuncia G1–G5 mais a fila de revisão
		como o contrato do gate de produção; a implementação no
		structural-check-runner é plannedOutput. O gate.py dos pilotos NÃO é
		adotado como produção — provou o desenho, não é o artefato.

		D2 — Ordem de materialização. Ordem fixa: (i) o schema aceita os campos
		(firstClass/shared/coreNoun/canonicalSchemaRef/canonicalTermRef); (ii) o
		glossário-kernel passa a existir com o termo canônico; (iii) o backfill
		dos elos roda em ondas; (iv) uma worklist/allowlist temporária cobre o
		pendente; (v) o gate roda em modo report; (vi) o gate vira blocking após
		cobertura mínima atingida. O backfill é campanha subsequente, não feito
		aqui.

		Non-goal. Esta decisão NÃO prova verdade semântica quando um elemento
		mimetiza outro em nome E shape simultaneamente (caso 4e) — isso é
		território de revisão P10/founder/self-review, não do gate
		determinístico. O limite tem dois regimes distintos, e a honestidade
		exige separá-los: (i) especialização coreNoun-DIVERGENTE (estilo bkr,
		nome diferente do canônico) é flagrada DETERMINISTICAMENTE pelo mismatch
		e roteada à fila de revisão; (ii) masquerade de nome E shape IDÊNTICOS
		(coreNoun igual, shape igual, refs resolvendo) é indistinguível de um
		conceito legítimo em TODO nível estrutural — o gate não dá falso-flag,
		mas também não o sinaliza: é pego SÓ por revisão humana/self-review
		periódica (por isso o gatilho-risco de def-062 é manual-review). O gate
		não promete cobertura que não tem. Detalhado em consequences.
		"""

	consequences: """
		Positivas. A camada de linguagem ubíqua ganha a maquinaria de governança
		que a camada de schema já tem: cada conceito de primeira classe passa a
		ter elo verificável ao domain-model. O gate é fechado-contra-evasão —
		órfão, vizinho-errado e duplicata local são pegos (G1/G3/E7), e o false
		desonesto é exposto por G4 mais a fila de revisão. A fresta original — o
		conceito central de um BC sem termo na linguagem — não reaparece, porque
		a omissão de marcação para quem cruza contrato vira erro de CI (G2), não
		lacuna silenciosa.

		Negativas (honestas).
		N1 — Backfill. Exige campos novos no domain-model (firstClass/
		firstClassReason/coreNoun/shared/canonicalSchemaRef/canonicalTermRef) e
		backfill desses elos nos 12 BCs — campanha em ondas, custo real de
		migração. Mitigado pela ordem D2: o gate roda em modo report antes de
		virar blocking, então a campanha não bloqueia trabalho enquanto a
		cobertura sobe.

		N2 — Cobertura não é correção. O gate mede COBERTURA (existe termo
		dedicado, ref resolve, nome corresponde?), não CORREÇÃO SEMÂNTICA (a
		definição está certa? o firstClass:false é honesto?). Qualidade de
		definição e honestidade da classificação ficam para o self-review humano
		— limite P10 declarado. O gate prova que há cobertura, não que a
		cobertura é verdadeira.

		N3 — Especialização sem mecanismo. Até def-062 resolver, a especialização
		local (bkr) fica sem campo dedicado: coberta pela Forma B com o mismatch
		de coreNoun indo à fila, mas sem declarar legitimidade. Precisão de tipo
		adiada — trade-off explícito em def-062.

		N4 — Pressupõe domain-model bem-decomposto. A Forma A pressupõe que
		conceitos distintos já são distintos no modelo. Um conceito escondido sob
		termo guarda-chuva (Money genérico mascarando receivable ou fee) NÃO é
		pego pelo gate — pré-requisito de modelagem, não falha do gate. Gate de
		cobertura sobre modelo mal-decomposto dá verde-falso: a garantia é
		condicional à qualidade da decomposição upstream.

		Non-goal (detalhado). O gate determinístico valida ESTRUTURA —
		existência, classificação, correspondência de nome via coreNoun,
		consistência bidirecional ref↔anotação. NÃO valida VERDADE SEMÂNTICA. Há
		dois regimes a separar com precisão. Regime (i): especialização
		coreNoun-DIVERGENTE (estilo bkr) — o mismatch entre coreNoun e termo
		canônico dispara, então é flagrada DETERMINISTICAMENTE e roteada à fila
		de revisão. Regime (ii): masquerade 4e de nome E shape IDÊNTICOS — um
		elemento com coreNoun igual ao canônico, shape igual e refs que resolvem,
		mas semanticamente distinto; por construção NÃO há sinal estrutural que o
		distinga do conceito genuíno (o mismatch não dispara, pois o nome é
		igual). Logo o gate não o sinaliza — só é exposto por revisão
		humana/self-review periódica (a razão de o gatilho-risco de def-062 ser
		manual-review). É FRONTEIRA da automação, não defeito a consertar com
		mais gate — empilhar regras determinísticas sobre sinal semântico
		produziria falsa precisão, o que P10 proíbe. A afirmação precisa: o gate
		não dá falso-flag, e o caso divergente não escapa; o masquerade idêntico
		depende de olho humano periódico, não de flag estrutural.
		"""

	// ── Rastreabilidade ──
	// Reparo 2 (leitura estrita decide-vs-edita): este ADR DECIDE; não edita
	// schema neste PR. affectedArtifacts fica vazio porque nada existente é
	// alterado AQUI.
	affectedArtifacts: []

	// NOTA (desvio consciente da convenção adr-059): por adr-059, artefato
	// existente-alterado iria em affectedArtifacts. Os dois primeiros itens
	// abaixo (glossary.cue, domain-model.cue) SÃO existentes-alterados, mas
	// vão em plannedOutputs porque a alteração acontece em PR follow-up, não
	// neste. Desvio deliberado pela leitura estrita decide-vs-edita — não é
	// erro. at-least-one-block-present (sc-adr-01) satisfeito por esta lista.
	plannedOutputs: [
		"architecture/artifact-schemas/glossary.cue",                                        // delta: canonicalPathRegex estendido
		"architecture/artifact-schemas/domain-model.cue",                                    // delta: firstClass/shared/coreNoun/canonicalSchemaRef/canonicalTermRef
		"architecture/shared-schemas/glossary.cue",                                          // novo: glossário-kernel + term-money canônico
		"architecture/structural-checks/first-class-traceability.cue",                       // novo: gate G1–G5 + fila de revisão
		"governance/build-time/first-class-backfill-worklist.cue",                           // novo: worklist/allowlist da campanha de backfill
		"architecture/deferred-decisions/def-062-local-specialization-shared-primitive.cue", // novo (neste PR): DD especialização Forma B.2
	]

	defersTo: ["def-062"]

	falsificationCondition: {
		condition: """
			Este ADR estará errado se qualquer uma das quatro se verificar: (1) o
			gate de produção precisar de heurística de name-matching difuso, em
			vez dos campos declarados (firstClass/coreNoun), para funcionar —
			provaria que a declaração explícita não basta e a governança real
			depende de adivinhação; (2) o lar canônico shared (extensão do
			#Glossary.canonicalPathRegex) criar ambiguidade de classificação ou
			regressão no structural-check-runner sobre os glossários existentes —
			provaria que a mudança de schema quebra mais do que resolve; (3)
			canonicalTermRef/canonicalSchemaRef não puderem ser checados
			deterministicamente por regra de structural-check — provaria que a
			Forma B não é verificável e vira convenção, não gate; (4) um conceito
			firstClass passar o gate sem termo dedicado E sem entrada explícita de
			worklist/deferral (verde-falso) — provaria que o gate dá falsa
			confiança, o medo dominante.
			"""
		observableSignal: """
			Os sinais dividem-se por QUANDO são falsificáveis. Falsificáveis
			AGORA: (2) a re-rodada de file_classification sobre os 12 glossários
			acusa órfão ou ambiguidade nova — o mesmo teste mecânico que o piloto
			3 já executou; (4) o diff entre o conjunto firstClass e o conjunto
			coberto (termo-dedicado ∪ worklist) é não-vazio sem bloquear.
			Falsificáveis SÓ NA MATERIALIZAÇÃO do gate (o structural-check de
			produção é plannedOutput, ainda não existe): (1) a forma da regra do
			gate revela matching difuso em vez de consumir os campos declarados;
			(3) a regra não consegue resolver canonicalTermRef/canonicalSchemaRef
			deterministicamente. Procurar o structural-check de (1)/(3) antes da
			materialização é categoria-erro: ele ainda não foi escrito.
			"""
	}

	principlesApplied: ["P0", "P1", "P10", "P12"]

	rationale: """
		Um banco operado por agentes exige que conceitos de negócio tenham
		significado estável e verificável: quando o conceito central de um BC não
		tem termo na linguagem ubíqua, humanos e agentes operam sobre um nome sem
		definição canônica. Esta decisão torna a cobertura semântica uma
		obrigação verificável por máquina, em vez de depender de inferência
		humana — a mesma disciplina que a Mesh aplica ao risco, aplicada à
		própria linguagem do sistema.

		Opção (4) entre (1)–(4): firstClass declarado + cobertura dedicada owned
		+ termo canônico shared com lar legal é a única leitura
		fechada-contra-evasão E conforme a P0. (1) name-matching é heurística —
		governança aparente; (2) cobertura local exige N cópias do termo,
		violando P0; (3) co-localização no schema esconde o termo do
		classificador de órfão (prova mecânica, piloto 3). A escolha é dirigida
		por evidência de disco (três pilotos contra o enforcer real), não por
		desenho abstrato.

		P0 (localização canônica única): o termo compartilhado vive em UM lar
		(glossário-kernel) e os BCs apontam por canonicalTermRef — ponteiro, não
		cópia; é exatamente o critério que rejeita a alternativa (2). P1 (schema é
		fonte de contrato): a maquinaria nasce como campos de schema CUE
		(#Glossary + domain-model), não como convenção — a declaração firstClass é
		contrato tipado e verificável, não anotação informal. P10 (gate
		determinístico valida, humano julga): G1–G5 validam ESTRUTURA; a verdade
		semântica (definição correta, firstClass:false honesto, masquerade 4e)
		fica com o humano — a separação é a linha que o non-goal protege. P12
		(governança é código): a omissão de cobertura para quem cruza contrato
		vira erro de CI (G2), não lembrete em documento — a regra que importa é
		imposta automaticamente.

		Tensão com axiomas: nenhuma. O deferimento da Forma B.2 (def-062) é
		known-gap governado com trade-off e gatilhos, não tensão.
		"""
}
