package tension_log

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

ten008: artifact_schemas.#TensionEntry & {
	id:    "ten-008"
	date:  "2026-04-07"
	title: "lens-platform-dynamics está instanciada em nível Mesh-específico, não em nível teórico-instrumental"

	kind:          "cross-artifact-friction"
	tensionTarget: "architecture/lenses/lens-platform-dynamics.cue"
	manifestsIn:   "architecture/lenses/lens-platform-dynamics.cue"

	description: """
		Durante a batch 2 do backfill piloto da Fase 1 de
		adr-043, ao classificar lens-platform-dynamics segundo
		o tipo #VerticalApplicability, emergiu uma observação
		que vai além da classificação: a lens, na sua forma
		atual, não opera no nível de abstração que seria
		esperado de uma analytical lens canônica.

		Uma analytical lens, conforme estabelecido pelo padrão
		das lenses já existentes no repo (commons-collective-action,
		supply-chain-theory, credit-risk, distributed-systems-design,
		temporal-modeling-for-financial-systems), é um instrumento
		teórico para raciocinar sobre uma classe de problemas. O
		núcleo conceitual é universal ou explicitamente parametrizado;
		a aplicação ao contexto Mesh vive em meshExamples e
		meshManifestation/meshImplication, claramente separados do
		núcleo.

		lens-platform-dynamics não segue esse padrão. Ela está
		substantivamente instanciada na Mesh como plataforma
		bootstrapada em construção civil brasileira, sem pontos
		de variação explicitados:

		- O purpose declara explicitamente "Analisar como a Mesh
		  cria, acelera, sustenta e defende efeitos de plataforma"
		  — não "como plataformas multi-sided geram, sustentam
		  e defendem efeitos de rede".

		- Conceitos centrais (pd-friction-threshold,
		  pd-multi-sided-structure, pd-platform-lifecycle,
		  pd-single-player-mode) embutem premissas
		  construção-específicas (concentração de compradores,
		  fornecedores como geradores de necessidade de crédito,
		  qualificação manual cara, fricção setorial)
		  diretamente em suas meshManifestation, não em
		  meshExamples separados.

		- Reasoning protocol pergunta "Em que estágio a Mesh
		  está", não "Em que estágio a plataforma sob análise está".

		- A própria seção limitations declara "Calibração depende
		  fortemente da vertical. Construção civil não generaliza
		  automaticamente para outras cadeias", confirmando
		  textualmente que a lens não é instrumento universal.

		Consequência para classificação: a lens foi corretamente
		classificada como vertical-specific no commit b459675,
		porque é o que reflete o estado atual do artefato. Mas
		essa classificação esconde uma observação mais profunda:
		o núcleo teórico de platform dynamics (Rochet-Tirole,
		network effects, multi-sided markets, chicken-and-egg,
		anchor tenants, envelopment, switching costs) é
		genuinamente universal — aplicável a qualquer plataforma
		multi-sided. A especificidade da lens não decorre de
		impossibilidade teórica, decorre de uma decisão de
		autoria que escolheu instanciar diretamente em vez
		de manter o nível teórico e separar instanciação.

		Esta tensão não ativa o gatilho de reabertura de ten-007
		(o schema #VerticalApplicability captura corretamente
		o caso atual como vertical-specific). Mas levanta uma
		classe de pergunta nova: classificação como diagnóstico
		de quality de autoria, não apenas de aplicabilidade.
		Outras lenses no repo podem estar na mesma situação e
		seriam candidatas a re-autoria similar.
		"""

	resolution: """
		Aceita como tensão aberta sem ação imediata. A
		classificação atual (vertical-specific) é honesta sobre
		o estado do artefato e não bloqueia o backfill da Fase 1
		de adr-043.

		Ação potencial futura, fora do escopo deste piloto:
		re-autoria de lens-platform-dynamics em dois passos
		separáveis — (a) extrair o núcleo teórico universal de
		platform dynamics como uma versão vertical-agnostic ou
		vertical-adaptable da lens, (b) manter a aplicação
		Mesh-específica em meshExamples ou em um artefato
		separado de tipo distinto (talvez um canvas, um
		strategic-analysis, ou um campo dedicado de
		platform-instance dentro do canvas da própria Mesh).

		Decisão sobre re-autoria pertence ao founder e depende
		de prioridade relativa: se o objetivo é ter platform
		dynamics como instrumento de raciocínio para outras
		decisões da Mesh, vale re-autorar; se o objetivo é
		documentar a Mesh como plataforma para fins estratégicos,
		o artefato atual pode ficar como está e migrar para
		outro tipo conceitual.

		Ganho da decisão de não agir agora: evita refatoração
		em meio ao backfill, mantém o piloto focado em
		classificação, e preserva o artefato existente como
		baseline observável caso a re-autoria seja feita depois
		(comparação direta possível).

		Perda aceita: a lens permanece classificada como
		vertical-specific quando uma versão re-autorada poderia
		ser agnostic ou adaptable. Esta perda é limitada ao
		plano de governança e interpretação do artefato; não
		afeta o funcionamento operacional imediato do sistema.

		Gatilho de reabertura: (a) decisão do founder de
		priorizar re-autoria, OU (b) identificação de ≥2 outras
		lenses no repo na mesma situação (mesma classe de
		instanciação direta de núcleo universal), o que
		sugeriria padrão e não caso isolado.
		"""

	status: "open"

	relatedADR: "adr-043"

	rationale: """
		Registro feito imediatamente após a primeira manifestação
		concreta da observação, dentro da batch 2 do piloto, e
		separado da entrada de classificação propriamente dita.
		A separação é deliberada: classificação (commit b459675)
		reflete estado atual; observação de quality de autoria
		(este artefato) reflete potencial futuro. Misturar as
		duas no mesmo registro confundiria leitores futuros
		sobre se a classificação foi correta ou se foi um
		workaround para um defeito de autoria. A entrada vive
		como tensão aberta — não como problema a resolver
		agora — para preservar opcionalidade sem perder o
		insight. Sem este registro, a observação vive apenas
		na conversa que gerou o commit, e seria irrecuperável
		para qualquer agente futuro.
		"""
}
