package design_system

// token-contract.cue — Contrato de tokens da Constituição do Design
// System (adr-194; seção VII da promulgação v1.0). Compõe a MESMA
// instância designSystemConstitution de constitution.cue (merge de
// structs CUE).
//
// P0 — spec é a LEI, runtime carrega os VALORES: cada token declara
// id, papel, de onde deriva (derivesFrom — enum fechado, cue vet),
// a moldura/valor (constraints) e o regime de mudança:
//   calibratable       → recalibrar DENTRO da moldura é manutenção
//                        (commit no mesh-frontend-runtime), sem reabrir
//                        a norma.
//   constitution-bound → o valor/range é fixado pela própria camada;
//                        alterá-lo exige emenda via ADR (cláusula IX).
// Os valores registrados em constraints são o REGISTRO DA PROMULGAÇÃO
// v1.0 (seção VII) — preservados aqui como registro histórico-normativo;
// a fonte VIVA dos valores vigentes é o mesh-frontend-runtime, sob este
// contrato.

designSystemConstitution: tokenContract: {
	promulgationNote: """
		Valores promulgados v1.0 (julho/2026, seção VII da Constituição). Este contrato é
		a lei de cada token (papel, derivação, moldura, regime de mudança); os valores
		exatos aqui registrados são o registro da promulgação — a fonte VIVA dos valores
		é o mesh-frontend-runtime, que os materializa sob este contrato (separação
		declarada em adr-194). Interação promulgada junto à paleta: hover escurece meio
		tom; pressionado = tinta plena; foco = contorno 2px afastado; links = tinta
		sublinhada.
		"""

	tokens: [{
		// ── Cor (VII, tabela promulgada) ──
		id:          "tinta"
		role:        "texto, ação primária, marca, malha"
		derivesFrom: "layers.color"
		constraints: "Valor promulgado e vinculado: #141414 sobre o papel — contraste 16,9:1 AAA. O hex está NA decisão-raiz de VI.1 ('preto no branco — #141414 sobre o papel — a tinta de registro'): a cor da marca repete a tese; única cor com direito a identidade e ação."
		changeRegime: "constitution-bound"
	}, {
		id:          "meta"
		role:        "metadados, rótulos, timestamps"
		derivesFrom: "layers.color"
		constraints: "Vigente: #555555 — contraste AAA sobre a página. Moldura: cinza de metadado quieto, AAA obrigatório; o hex exato é implementação dentro da moldura (VI.1: paleta mínima com empregos fixos), calibrável sem reabrir a norma."
		changeRegime: "calibratable"
	}, {
		id:          "pagina"
		role:        "superfície permanente (suporte)"
		derivesFrom: "layers.color"
		constraints: "Vigente: #faf8f4. A própria norma declara a moldura: 'valor exato ajustável por teste ao sol' (VII) / 'valor exato ajustável pelo teste de campo, sem reabrir a norma' (VI.1 trade-offs). Off-white que retira protagonismo da interface (VI.1 superfície); sem textura, ruído ou grão."
		changeRegime: "calibratable"
	}, {
		id:          "campo"
		role:        "superfície de escrita: campos de entrada"
		derivesFrom: "layers.color"
		constraints: "Valor promulgado e vinculado: #ffffff — branco puro. O emprego está NA norma de superfície de VI.1: 'O branco puro ganha emprego: superfície de escrita (campos de entrada)' — branco puro é a decisão, não um valor dentro de moldura."
		changeRegime: "constitution-bound"
	}, {
		id:          "bloco-de-agente"
		role:        "conteúdo preparado pela Mesh"
		derivesFrom: "layers.provenance"
		constraints: "Vigente: #edebe4. Moldura: fundo-apoio quieto do tratamento 'Preparado (agente)' (VI.6 mapeamento), distinto da página, sem drama; o hex exato é calibrável dentro da moldura. Ao confirmar, o fundo sai (VI.6 regra 1)."
		changeRegime: "calibratable"
	}, {
		id:          "borda-funcional"
		role:        "contorno de campo e controle"
		derivesFrom: "layers.color"
		constraints: "Vigente: #878787 — contraste 3,4:1 ✓ UI. Moldura com piso vinculado: emprego funcional exige contraste ≥3:1 (VI.1 decisões derivadas: 'Borda em dois empregos: funcional (contraste ≥3:1) e estrutural'); o hex acima do piso é calibrável."
		changeRegime: "calibratable"
	}, {
		id:          "filete-estrutural"
		role:        "separadores"
		derivesFrom: "layers.form"
		constraints: "Vigente: #c8c8c8 — decorativa. Moldura: filete é um dos quatro empregos de contorno (VI.4: 'filete (separação mínima)'); intensidade exata calibrável, desde que permaneça separação mínima, nunca moldura."
		changeRegime: "calibratable"
	}, {
		id:          "fato-bom"
		role:        "aprovada, convertida, verificação ok"
		derivesFrom: "layers.color"
		constraints: "Vigente: #2d6a00 — AA. Moldura vinculada à camada: emprego fixo (verde QUIETO de desfecho/verificação — VI.1: 'aprovada/convertida verdes quietas'; ✓ verde-quieto em VI.6), piso de contraste AA, quietude (cor pertence aos fatos, não decora); o hex é calibrável dentro dela."
		changeRegime: "calibratable"
	}, {
		id:          "erro-do-sistema"
		role:        "campo inválido, falha operacional"
		derivesFrom: "layers.color"
		constraints: "Vigente: #b00000 — AA. Moldura vinculada: vermelho VIVO exclusivo de erro do sistema, distinto por decisão de camada do desfecho negativo quieto (VI.1: 'Vermelho desdobrado: erro do sistema (vivo) ≠ desfecho negativo legítimo (quieto)'); piso AA; hex calibrável."
		changeRegime: "calibratable"
	}, {
		id:          "desfecho-negativo"
		role:        "rejeitada — decisão legítima, sem alarme"
		derivesFrom: "layers.color"
		constraints: "Vigente: #8a1010 — AAA. Moldura vinculada: vermelho QUIETO ('rejeição é o sistema funcionando, não falhando' — VI.1); piso AAA; sem alarme; hex calibrável dentro da moldura."
		changeRegime: "calibratable"
	}, {
		id:          "recibo"
		role:        "confirmação, evidência registrada"
		derivesFrom: "layers.provenance"
		constraints: "Vigente: #006677 — AA. Moldura: cor de recibo do tratamento 'Registrado (evidência)' (VI.6: voz mono + cor de recibo); emprego fixo, piso AA, quietude; hex calibrável."
		changeRegime: "calibratable"
	}, {
		id:          "limite-declarado"
		role:        "postura do sistema, escalada"
		derivesFrom: "layers.color"
		constraints: "Vigente: texto #7a3d00 · borda tracejada #964b00 — AAA. Moldura vinculada: o TRACEJADO é decisão de camada (VI.1 teste dos cinco: 'limites com tratamento próprio (tracejado)'; VI.4: 'tracejada (limite declarado)'; escalada é o único estado que acende — VI.1); os hex são calibráveis dentro do piso AAA e da quietude."
		changeRegime: "calibratable"
	}, {
		// ── Interação (VII, linha promulgada junto à paleta) ──
		id:          "hover"
		role:        "estado hover de controles"
		derivesFrom: "layers.color"
		constraints: "Vigente: hover escurece meio tom. Moldura: escurecimento sutil sem cor nova nem efeito (VI.1: proibido sombra/gradiente/elevação); o passo exato é calibrável."
		changeRegime: "calibratable"
	}, {
		id:          "pressionado"
		role:        "estado pressionado de controles"
		derivesFrom: "layers.color"
		constraints: "Promulgado e vinculado: pressionado = tinta plena. Amarrado ao token tinta (#141414) — a tinta é a única cor com direito a ação (decisão-raiz VI.1); não há valor livre a calibrar."
		changeRegime: "constitution-bound"
	}, {
		id:          "foco"
		role:        "indicador de foco"
		derivesFrom: "layers.color"
		constraints: "Promulgado e vinculado: foco = contorno 2px afastado. Decisão derivada da própria camada (VI.1: 'Foco visível: contorno 2px afastado') — alterar exige emenda."
		changeRegime: "constitution-bound"
	}, {
		id:          "links"
		role:        "estilo de link"
		derivesFrom: "layers.color"
		constraints: "Promulgado e vinculado: links = tinta sublinhada. Decisão derivada da própria camada (VI.1: 'Links: tinta sublinhada — sublinhado só existe para isso'); trade-off nomeado em VI.2 (menos 'elegantes' — em troca, clicabilidade nunca ambígua)."
		changeRegime: "constitution-bound"
	}, {
		// ── Tipografia (VII) ──
		id:          "familia"
		role:        "família tipográfica das três vozes"
		derivesFrom: "layers.typography"
		constraints: "Vigente: IBM Plex Sans (texto e dados tabulares) + IBM Plex Mono (evidência). Moldura da própria camada: titular declarada entre finalistas equivalentes (não inevitável), REVERSÍVEL POR UM TOKEN; reservas qualificadas Atkinson Hyperlegible Next + Mono (assume se o campo derrotar a Plex em legibilidade) e Mona Sans (se o caráter pedir revisão; tabulares a verificar). Troca dentro das reservas qualificadas é calibração; sair do regime de três vozes seria emenda."
		changeRegime: "calibratable"
	}, {
		id:          "escala"
		role:        "escala tipográfica com emprego fixo"
		derivesFrom: "layers.typography"
		constraints: "Vigente: 24 título de página · 20 seção · 16 corpo · 14 metadado · 13 tabela densa (escritório apenas). Pisos celular: 16 corpo, 14 meta. Moldura: cinco tamanhos com emprego fixo e pisos generosos (VI.2: 'Disciplinada: três pesos, cinco tamanhos'); os valores exatos são calibráveis dentro dela (ex.: teste ao sol)."
		changeRegime: "calibratable"
	}, {
		id:          "pesos"
		role:        "pesos tipográficos"
		derivesFrom: "layers.typography"
		constraints: "Promulgado e vinculado: 400 / 500 / 600 — três pesos, com empregos nomeados NA camada (micro-rótulos: peso 500, cor meta; desfechos: peso 600 + primeira posição — VI.2 decisões derivadas) e LIGHT BANIDO ('Light banido: morre ao sol'). Peso marca o que mudou ou espera decisão (decisão-raiz VI.2) — alterar o conjunto exige emenda."
		changeRegime: "constitution-bound"
	}, {
		id:          "entrelinha"
		role:        "entrelinhas por emprego"
		derivesFrom: "layers.typography"
		constraints: "Vigente: 1,5 corpo · 1,35 tabela · 1,2 título. Moldura: legibilidade por emprego (corpo respirado, tabela densa, título compacto); valores exatos calibráveis dentro dela."
		changeRegime: "calibratable"
	}, {
		// ── Espaço e forma (VII) ──
		id:          "grid"
		role:        "grade de espaçamento"
		derivesFrom: "layers.form"
		constraints: "Promulgado e vinculado: grid 8pt (meio-passo 4 interno a componentes). Decisão derivada da própria camada (VI.4: 'Grid 8pt, meio-passo de 4 só dentro de componentes — convenção adotada por Padrão de Excelência'); alterar exige emenda."
		changeRegime: "constitution-bound"
	}, {
		id:          "raio"
		role:        "raio de canto"
		derivesFrom: "layers.form"
		constraints: "Promulgado e vinculado: raio 0. O valor está NA decisão-raiz de VI.4 ('Raio zero em tudo — o documento é consequência, não causa'); a própria seção VII usa 'um raio diferente de zero' como o exemplo canônico do que é impossível sem emenda."
		changeRegime: "constitution-bound"
	}, {
		id:          "alvos-de-toque"
		role:        "alvos de toque mínimos"
		derivesFrom: "layers.form"
		constraints: "Vigente: ≥48px celular, ≥40px desktop. Moldura com piso vinculado: canteiro folgado com alvos 48px+ está NA camada (VI.4 densidades); o valor desktop e ajustes acima dos pisos são calibráveis."
		changeRegime: "calibratable"
	}, {
		id:          "densidade-canteiro"
		role:        "densidade do modo canteiro"
		derivesFrom: "layers.form"
		constraints: "Vigente: respiros 16/24. Moldura: canteiro é o token de densidade FOLGADO (VI.4: 'canteiro (folgado, alvos 48px+)'); valores exatos de respiro calibráveis dentro do caráter folgado."
		changeRegime: "calibratable"
	}, {
		id:          "densidade-escritorio"
		role:        "densidade do modo escritório"
		derivesFrom: "layers.form"
		constraints: "Vigente: linhas ~32px, respiros 8/16, seções 24/32. Moldura: escritório é o token de densidade DENSO (VI.4: 'escritório (denso, linhas ~32px)' — a própria camada registra o valor como aproximado); valores exatos calibráveis dentro do caráter denso."
		changeRegime: "calibratable"
	}, {
		// ── Movimento (VII) ──
		id:          "movimento-elementos"
		role:        "duração de transição de elementos"
		derivesFrom: "layers.motion"
		constraints: "Range promulgado e vinculado: 120–200ms (VI.3 jurisprudência: 'tempo mínimo para continuidade perceptiva'). O RANGE é bound — o valor exato dentro dele é calibrável; sair dele exige emenda."
		changeRegime: "constitution-bound"
	}, {
		id:          "movimento-superficie"
		role:        "assentamento de superfície inteira"
		derivesFrom: "layers.motion"
		constraints: "Range promulgado e vinculado: ≤240ms, único, não bloqueante, jamais somado à espera de dados (VI.3). O teto e as condições são bound; o valor dentro do teto é calibrável."
		changeRegime: "constitution-bound"
	}, {
		id:          "movimento-easing"
		role:        "curva e caráter do movimento"
		derivesFrom: "layers.motion"
		constraints: "Promulgado e vinculado: ease-out, chegada firme, sem bounce (VI.3 jurisprudência). Caráter do movimento é decisão de camada — não há valor livre a calibrar."
		changeRegime: "constitution-bound"
	}, {
		id:          "movimento-decaimento-realce"
		role:        "decaimento de realce de novidade"
		derivesFrom: "layers.motion"
		constraints: "Range promulgado e vinculado: 1–3s, decai UMA vez, sem repetir nem piscar (VI.3: 'estado expirando, não transição'). O range e a unicidade são bound; o valor dentro do range é calibrável."
		changeRegime: "constitution-bound"
	}, {
		id:          "movimento-acao-do-usuario"
		role:        "resposta a ação do usuário"
		derivesFrom: "layers.motion"
		constraints: "Promulgado e vinculado: início instantâneo — a transição é consequência, nunca espera (VI.3 jurisprudência). Não há valor a calibrar: instantâneo é a decisão."
		changeRegime: "constitution-bound"
	}]
}
