package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr152: artifact_schemas.#ADR & {
	id:    "adr-152"
	title: "Substituir auto-commit pós-merge dos derivados por gate de drift no PR"
	date:  "2026-06-16"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		Os três artefatos derivados de discovery do repositório — structure-index.cue
		(adr-090), tree-generated.cue e README.md (adr-115) — eram mantidos em sync por
		auto-commit pós-merge: os workflows materialize-structure-index.yml e
		materialize-repo-tree.yml regeneram o derivado em push para main e tentam
		commitar a diferença de volta. O CLAUDE.md, derivado-irmão gerado de
		governance/claude/config.cue, NÃO usa esse modelo: vive no step "Check CLAUDE.md
		sync" de validate.yml — gate de drift no PR (regenera da fonte, diffa contra o
		committed, falha com ::error:: se divergir), zero auto-commit. É prova viva, no
		próprio repo, de que o gate de drift convive com a branch-protection.

		GATILHO. WI-141 (ação b) diagnosticou com log ao vivo que o auto-commit
		pós-merge bate em GH013 (a regra "main exige pull request"): o bot commita local
		mas o `git push origin HEAD:main` é rejeitado pela branch-protection, e o
		`|| echo "push falhou..."` engole a rejeição — o workflow fica verde e o derivado
		fica stale. Os dois derivados auto-commitados estavam parados em ~adr-133
		(faltando adr-134..151, def-035..062, schemas novos) por dezenas de merges. O
		regime auto-commit-direto-em-main é estruturalmente incompatível com
		main-exige-PR: não é bug de permissão a remendar, é incompatibilidade de design
		entre empurrar direto ao main e exigir PR para o main.

		AMEND (não supersede). Esta decisão não inverte adr-090 nem adr-115 — cumpre o
		que ambos já decidiram, corrigindo a implementação que divergiu. adr-115
		consequência (3) já prometia, verbatim: "a árvore do README fica auto-sincronizada
		e o drift por omissão é eliminado — o gate deterministic falha se o derivado
		estiver fora de sync". O gate que falha era a decisão; o auto-commit que engole a
		falha foi a divergência. adr-090 consequência (2) descreveu o gerador como
		"a primeira regeneração AUTO-CORRIGE o mapa — conserto e detector ao mesmo tempo"
		— o gate de drift é exatamente esse detector. As decisões-núcleo de 090 (derivar
		a estrutura do filesystem, matar a duplicação config↔schema) e de 115 (meta.cue
		por diretório, tree derivado→README) permanecem intactas; adr-152 troca só o
		mecanismo de sync.

		DISTINÇÃO DA ALTERNATIVA QUE adr-090 REJEITOU. adr-090 rejeitou (verbatim) "gates
		detectando a divergência (config-path-existence permanente)" porque "config.cue é
		aspiracional" — gate sobre afirmações aspiracionais do config inunda de
		falso-positivo. O gate do adr-152 é de categoria diferente: opera sobre o DERIVADO
		DETERMINÍSTICO (regenera o artefato pelo gerador e diffa contra o committed), não
		sobre paths aspiracionais. Derivado determinístico ou bate ou não bate — não há
		falso-positivo aspiracional. A distinção é explícita para que adr-152 não pareça
		reabrir o que adr-090 fechou.

		ALTERNATIVAS CONSIDERADAS.
		(a) Consertar o auto-commit dando ao bot push direto ao main (exceção de
		    branch-protection / token elevado). Rejeitada: contornaria a branch-protection
		    que existe por design (main exige PR + status checks obrigatórios); trocar
		    integridade do main por conveniência de sync de derivado é a barganha errada.
		(b) O workflow abre um PR automático com a regeneração em vez de commitar direto.
		    Rejeitada: mantém a assincronia frágil (derivado correto só DEPOIS do merge,
		    com janela de drift) e gera PRs-de-bot paralelos a revisar/mergear — mais
		    superfície operacional, não menos.
		(c) Gate de drift no PR + script ergonômico de regeneração, descomissionando o
		    auto-commit. ESCOLHIDA: síncrono (derivado correto no momento do merge, sem
		    janela de drift), audível por construção (drift vira check vermelho, não log
		    engolido) e espelha o step do CLAUDE.md que já funciona com a branch-protection.
		"""

	decision: """
		Substituir o auto-commit pós-merge dos três derivados por um gate de drift no
		PR, espelhando o step "Check CLAUDE.md sync" de validate.yml. Quatro partes.

		(1) GATE (a lei). validate.yml ganha três steps de drift, um por derivado
		(structure-index.cue, tree-generated.cue, README.md). Cada step regenera o
		derivado da fonte, diffa contra o committed e falha com ::error:: + exit 1 se
		divergir. Roda em [push, pull_request] como o step do CLAUDE.md: no PR bloqueia o
		merge com drift; no push para main é o sinal audível (o que o `|| echo` engolia).
		Determinístico, zero LLM (P10) — regenera e diffa, não interpreta.

		(2) WIRING (P0). Cada step chama scripts/ci/regenerate-derived.sh --check <alvo>
		— a receita de regenera-e-diffa vive uma única vez no script; gate e autor
		consomem a MESMA lógica pelo MESMO caminho de código. Isso fecha o gap
		generate-vs-compile (o caminho que o gate valida é o caminho que o autor executa)
		e honra Zero Duplicação: a regra não é reescrita inline no YAML.

		(3) SCRIPT (ergonomia). scripts/ci/regenerate-derived.sh [--check], espelhando
		rebuild-projections.sh (bash + heredoc) e o --check de
		mesh-runtime/scripts/regenerate.sh. Sem flag: regenera os três na ordem de
		dependência (structure-index → tree-generated → README, pois o README consome o
		tree via cue export ./governance/readme) e deixa o resultado no working tree — o
		autor commita a regeneração dentro do PR. Com --check <alvo>: regenera AQUELE alvo
		a partir de suas fontes reais, diffa contra o committed DAQUELE alvo, exit
		não-zero em drift. Os três --check juntos cobrem a cadeia de dependência: um drift
		em QUALQUER elo — inclusive um intermediário como o tree — é pego pelo --check
		daquele elo, independente dos outros. Em particular, o --check do README não passa
		verde só porque bate com um tree-committed-stale: o drift do tree é pego pelo
		--check do tree, que regenera o tree de _meta.cue + scan do filesystem, não de
		derivado-committed. Por isso são três steps independentes, não um único check do
		artefato final. (No modo sem-flag a ordem structure-index → tree → README
		permanece, pois sem-flag reescreve a cadeia inteira; a verificação por-fontes é a
		precisão do modo --check.) CRÍTICO: o script NUNCA auto-commita — a escrita do
		derivado fica no PR governado, revisável, nunca num push direto do bot ao main.

		(4) DESCOMISSIONAR. Remover materialize-structure-index.yml e
		materialize-repo-tree.yml — os dois "git push || echo", estruturalmente
		incompatíveis com main-exige-PR. Saem no MESMO PR em que o gate entra: nunca há
		estado intermediário em que o derivado fique sem proteção (o gate cobre antes do
		auto-commit sair).

		NOTA — assimetria conhecida. O step do CLAUDE.md permanece inline em validate.yml
		nesta peça (não migrado ao script). É deliberado, não descuido: o CLAUDE.md já
		funciona e está fora do escopo do drift dos três derivados de discovery.
		Unificá-lo ao mesmo script é follow-up OPCIONAL (colocaria os quatro derivados sob
		um caminho único), registrado aqui para não reabrir como achado.
		"""

	consequences: """
		Positivas. (1) Gate SÍNCRONO: o derivado está correto no momento do merge, sem
		janela de drift transitória — o auto-commit deixava o derivado stale até um
		próximo push landar, que nunca landava. (2) Falha AUDÍVEL por construção: drift
		vira check vermelho no PR, impossível de ignorar; substitui o `|| echo` que ficava
		verde enquanto o derivado apodrecia. (3) Restaura a intenção de adr-090 (c2, o
		detector) e adr-115 (c3, o gate que falha em drift), corrigindo a divergência do
		auto-commit.

		Negativas (honestas).
		N1 — FARDO NO AUTOR. Toda mudança que afeta um derivado passa a exigir que o autor
		regenere (regenerate-derived.sh sem-flag) e commite a regeneração no PR — trabalho
		que o auto-commit fazia (mal) por ele. Mitigado: um comando regenera os três na
		ordem certa, e o ::error:: do gate nomeia EXATAMENTE qual derivado regenerar.
		N2 — ASSIMETRIA CLAUDE.md. O step do CLAUDE.md fica inline; os três derivados via
		script — formas diferentes para o mesmo padrão até o follow-up opcional unificar.
		Conhecida e declarada (NOTA na decisão), não descuido.
		N3 — DEPENDÊNCIA DE DETERMINISMO. O gate é tão confiável quanto os geradores serem
		determinísticos; um gerador que virasse não-determinístico produziria
		falso-positivo (drift fantasma). Mitigado: os geradores foram provados
		determinísticos (WI-141 ação a, regeneração idempotente batendo com o disco); um
		gerador não-determinístico seria bug a consertar no gerador, não falha do gate.
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	falsificationCondition: {
		condition: """
			adr-152 estaria errado se o gate de drift produzisse falso-positivo RECORRENTE
			— drift fantasma sinalizado sem mudança real no derivado nem em suas fontes —,
			provando que regenera-e-diffa não é detector confiável e que o ônus no autor
			(N1) não tem contrapartida de correção real.
			"""
		observableSignal: """
			PRs que não tocam nenhum dos três derivados nem suas fontes (_schema.location,
			_meta.cue, config.cue, filesystem governado) começarem a falhar os steps de
			drift do validate.yml.
			"""
	}

	affectedArtifacts: [
		".github/workflows/validate.yml",                    // +3 steps de drift (um por derivado)
		".github/workflows/materialize-structure-index.yml", // removido (auto-commit incompatível com main-exige-PR)
		".github/workflows/materialize-repo-tree.yml",       // removido (idem)
		"governance/repo-structure.cue",                     // rationale l.88: regime de sync passa a gate de drift
		"architecture/adrs/adr-115-auto-sync-repo-tree.cue", // ponteiro l.122: "descomissionado por adr-152" (preserva histórico)
		"scripts/ci/rebuild-projections.sh",                 // header l.36-37: o --check prometido como future WI é entregue
	]

	// derivedArtifacts: omitido — adr-152 muda o mecanismo de sync, não o conteúdo
	// dos derivados; nenhum artefato é regenerado COMO CONSEQUÊNCIA desta decisão.
	plannedOutputs: [
		"scripts/ci/regenerate-derived.sh",
	]

	principlesApplied: [
		"P0 — Zero Duplicação: a receita regenera-e-diffa dos derivados vive uma única vez em scripts/ci/regenerate-derived.sh (wiring b); o gate de CI e o autor a consomem, sem cópia.",
		"P10 — gate determinístico: o drift é detectado por regeneração + diff (zero LLM), reproduzível; substitui o auto-commit que falhava em silêncio por validação determinística no PR.",
		"P12 — governança-como-código: o sync dos derivados deixa de ser regra não-imposta (auto-commit que engolia a rejeição da branch-protection) e passa a ser imposto automaticamente no CI — 'toda regra que importa é imposta automaticamente'.",
		"adr-090 — AMEND: o gate de drift é o detector que adr-090 consequência (2) já descreveu ('conserto e detector'); distinto do gate de config-path-existence que adr-090 rejeitou (aquele sobre o config aspiracional, este sobre o derivado determinístico). Decisão-núcleo de 090 (derivar do filesystem) intacta.",
		"adr-115 — AMEND: cumpre a consequência (3) que adr-115 prometeu ('o gate deterministic falha se o derivado estiver fora de sync'); o auto-commit que shipou foi a divergência. Decisão-núcleo de 115 (meta.cue + tree derivado→README) intacta.",
	]

	defersTo: []

	rationale: """
		Opção (c) entre as alternativas (a)-(c) do context: gate de drift no PR + script
		de regeneração, descomissionando o auto-commit. (a) push direto do bot ao main
		contornaria a branch-protection que existe por design; (b) PR automático do bot
		mantém a assincronia e multiplica PRs a revisar; (c) é a única que torna o derivado
		correto NO momento do merge e a falha audível por construção — espelhando o gate do
		CLAUDE.md que já convive com a branch-protection.

		decisionClass structural: muda o contrato de validação de CI (adiciona gate
		bloqueante, remove dois workflows), sem redefinir princípio base nem SoT de
		domínio. reversibility medium: reverter exige restaurar os workflows materialize-*
		e remover o gate/script — esforço moderado, sem impacto em dado persistido ou
		contrato público. blastRadius repo-wide: o gate roda em todo PR e impõe a obrigação
		de regen a todo contribuidor.

		P0 (localização canônica única): a receita regenera-e-diffa vive em UM lar —
		scripts/ci/regenerate-derived.sh — e o gate de CI a consome via --check; o YAML não
		reescreve a lógica inline (wiring b). P10 (gates determinísticos validam, agentes
		estocásticos só recomendam): o drift é detectado por regeneração + diff, zero LLM,
		reproduzível — substitui o auto-commit que falhava em silêncio por validação
		determinística que bloqueia o merge. P12 (governança é código): o sync dos
		derivados deixa de ser regra não-imposta (o `|| echo` engolia a rejeição da
		branch-protection e ficava verde) e passa a ser imposto automaticamente no CI — a
		regra que importa é imposta, não documentada.

		Os dois entries de adr em principlesApplied registram o AMEND, não supersessão.
		adr-090: o gate de drift é o "detector" que sua consequência (2) já descreveu
		(regeneração que conserta-e-detecta); é categoria distinta do gate de
		config-path-existence que adr-090 rejeitou — aquele operava sobre o config
		ASPIRACIONAL (falso-positivo por construção), este sobre o derivado DETERMINÍSTICO
		(bate ou não bate). A decisão-núcleo de 090 (derivar a estrutura do filesystem,
		matar a duplicação config↔schema) fica intacta. adr-115: o gate CUMPRE a
		consequência (3) que 115 prometeu (o gate que falha se o derivado estiver fora de
		sync); o auto-commit que shipou foi a divergência. A decisão-núcleo de 115 (meta.cue
		por diretório, tree derivado→README) fica intacta. Como nenhuma decisão-núcleo é
		invertida, supersedes/supersededBy ficam vazios — supersessão exigiria status
		superseded em 090/115, que não se aplica.

		Tensão com axiomas: nenhuma. O follow-up opcional de unificar o CLAUDE.md ao mesmo
		script (N2) é assimetria declarada, não tensão; e a dependência de geradores
		determinísticos (N3) é propriedade já provada (WI-141 ação a), não força
		concorrente.
		"""
}
