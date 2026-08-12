---
name: mesh-issue-format
description: Formato obrigatório para criar ou editar issues do time Mesh no Linear (via MCP). Use SEMPRE que for criar uma tarefa, achado ou editar a descrição de uma issue no Linear do workspace meshbr. Garante que toda issue nasça no schema v2 (ordem contrato-primeiro, outputs parseáveis, predicado de conclusão, camada de escrita gated).
---

# mesh-issue-format — Formato de tarefa Mesh (v2)

ARTEFATO DERIVADO de DUAS fontes canônicas no Linear (Team Documents),
cada uma com snapshot e precedência próprios sobre a seção correspondente:

- **"Formato de tarefa Mesh (v2)"** — Tarefa e regras gerais
  (https://linear.app/meshbr/document/formato-de-tarefa-mesh-v2-27d21ff29e29)
  — snapshot: updatedAt 2026-08-12T15:26:25.029Z.
- **"Achado Mesh (v1)"** — o tipo Achado
  (https://linear.app/meshbr/document/achado-mesh-v1-b84970e05b82)
  — snapshot: updatedAt 2026-08-12T01:22:34.706Z.

Regra de re-derivação POR FONTE: se o `updatedAt` retornado pelo Linear
para uma fonte for POSTERIOR ao snapshot correspondente, AQUELA FONTE
VENCE — leia-a via MCP (`get_document`) e sinalize que a seção derivada
dela precisa de re-derivação. Fonte atualizada não invalida as seções
derivadas da outra. Nunca invente formato de memória.

## Princípio

A tarefa é uma **ordem de serviço para um agente**; humano por exceção
(Mesh é agent-operated). Estrutura parseável primeiro, prosa depois.
Isto é um **schema**, não um template para colar: campos nomeados,
obrigatoriedade definida por tier, sintaxe machine-readable, predicado
de conclusão.

## Tipos

- **Tarefa** — trabalho planejado. Cross-repo é **variação por label
  `repo:`** coerente com o repo alvo, não tipo próprio — o label roteia
  a verificação para o repo alvo. Use um label `repo:<repo-alvo>`
  EXISTENTE; não crie nova taxonomia de repo pela Skill.
- **Achado** — tipo semântico próprio, distinto de Tarefa (label
  `achado`; usa o workflow compartilhado, não workflow próprio).
  Governado por "Achado Mesh (v1)" — ver seção "Achado" abaixo.

## Campos da Tarefa — ordem contrato-primeiro

### Representação dos campos

Cada campo estrutural começa em início de linha, com o nome canônico
exato em negrito, seguido de dois-pontos:

```text
**Objetivo:**
**Outputs:**
**Feito quando:**
**Regime de escrita:**
**Classificação:**
**Fronteiras de autoridade (Stop Conditions):**
**Protocolo de escalação:**
**Contratos a ler** (base: `<sha>`):
**Rationale:**
```

- nome canônico **exato** — sinônimo não é campo;
- `**` obrigatório; `:` obrigatório;
- em `Contratos a ler`, o negrito fecha antes do complemento e os
  dois-pontos vêm depois de `(base: <sha>)`;
- `.` no lugar de `:` **não** é equivalente; heading **não** é
  equivalente;
- nome fora desta lista não é campo estrutural.

`Rationale` é opcional como campo; quando presente, sua representação
é tão estrita quanto a dos demais.

### Núcleo (SEMPRE obrigatório)

1. **Objetivo** — 1 linha: o efeito a atingir. Não "implementar X" — o
   que passa a ser verdade depois que X existe.
2. **Outputs** — sintaxe ESTRITA, um por linha:

   ```text
   - [ ] `<path>` *(create|update)*
   ```

   É o contrato do executor e da vigilância C2. Cross-repo: cada path
   prefixado pelo repo alvo:

   ```text
   - [ ] `<repo-alvo>/<path>` *(create|update)*
   ```

   O path é token literal e deve estar entre crases. A ausência das
   crases torna o marcador malformado para fins de enforcement.
3. **Feito quando** — predicado de conclusão. A forma é ditada pela
   **classificação do trabalho**, não pela escolha do autor:
   - *scaffold puro* → paths existem;
   - *comportamental/semântico* → **prova por artefato**:
     structural-check verde OU effectProof
     `repo · commit · gate · conclusão · link`.
     **SKIPPED nunca é verde** — gate que não rodou não prova nada;
     declarar por que não rodou.
   - *descoberta* (fan-out) → **cláusula de completude obrigatória**:
     oráculo independente (enumerar o universo + asserir cobertura).
     "Gate verde" é necessário mas NÃO suficiente — o estado inicial
     pode ser verde-por-vacuidade (RT-FMT-13).

### Camada de escrita (obrigatória quando a tarefa escreve em repo governado)

4. **Regime de escrita** — ponteiro: segue o regime **gated** do repo
   alvo (propor no chat → OK → commit → OK → push + freshness gate). A
   issue NÃO autoriza escrita direta. Este campo carrega o guard para o
   agente que não conhece o CLAUDE.md do repo alvo (RT-FMT-14).
5. **Classificação** — `instanciação` | `semântica → ADR no mesmo
   commit`. Regras: **na dúvida, semântica**. Instanciação é
   CONDICIONAL a schema + production-guide já existirem; se não
   existem, é criação de tipo → **escalar, não instanciar** (RT-FMT-07).
   Guarda determinística: tocar `schemas/`, `design-principles`,
   `structural-checks/` ou política de gate de CI ⇒ semântica ⇒ ADR.
6. **Fronteiras de autoridade (Stop Conditions)** — regra **POSITIVA
   permanente**, não lista fechada: *qualquer decisão semântica /
   irreversível / cross-tenant / legal → escalar, não decidir*. Itens
   listados na issue são EXEMPLOS, nunca a cerca (RT-FMT-03).
7. **Protocolo de escalação** — determinístico:
   `Stop Condition → cessar mutações → registrar escalation record →
   status = escalated → encerrar execução`.
   Retomada: a autoridade responde no próprio issue e o devolve a
   In Progress. NÃO usar achado na Triagem como parada — semânticas
   distintas. Schema do record abaixo.
8. **Contratos a ler** — ponteiros `path/id` para artefatos DURÁVEIS
   (schemas/ADRs de domínio), nunca governança que será removida
   (RT-FMT-04). Carimbar o commit (`base: <sha>`) para evitar skew
   entre a issue e o contrato de agora (RT-FMT-05).

### Humano (opcional)

9. **Rationale** — prosa; o agente executor pode pular. O "porquê" para
   o humano.

## Tiering (anti-cerimônia — RT-FMT-08)

- Tarefa que NÃO escreve em repo: só o núcleo (1–3).
- Tarefa que ESCREVE em repo governado: núcleo + camada de escrita (4–8).
- Rationale sempre opcional.

## Rodapé e estado

- **Sem linha "Estado:"** no corpo — o campo nativo do Linear é a fonte
  corrente do estado.
- Sem rodapé de origem em tarefa nova (o rodapé "Origem histórica"
  existe só nas 138 issues migradas, snapshot congelado em `61e296c`).

## Schema do escalation record

Registrado como comentário estruturado na issue (até haver custom field
nativo). O ESTADO `escalated` é o sinal machine-native; o record é o
payload.

```
escalation:
  authority: founder | architecture | risk | compliance   # hoje quase tudo → founder
  reason:              # por que parou
  triggered_condition: # qual Stop Condition disparou
  evidence:            # o que sustenta
  decision_required:   # o que a autoridade precisa decidir
  resume_condition:    # o que destrava a retomada
```

Fronteira: se `authority` virar como a Mesh roteia TODA decisão, é
conceito de **spec** (ADR no mesh-spec), não convenção do Linear.

## Achado (fonte: "Achado Mesh (v1)")

Achado é um tropeço registrado: o fato observado durante outro
trabalho, não o trabalho em si. Separa fato de interpretação: o campo
Achado contém apenas o observado; impacto e decisão ficam em campos
separados. Hipóteses causais, quando existirem, não fazem parte do
fato observado.

Não é Tarefa (sem Objetivo/Outputs/Feito quando — se merece trabalho,
a disposição cria a Tarefa). Não é escalação (escalação é transição de
ordem EM EXECUÇÃO para `escalated`; Achado é entrada NOVA na Triagem).

Nasce na Triagem, com label `achado`. Fecha SOMENTE por disposição
válida — silêncio, arquivamento ou passagem do tempo não substituem.

Campos (todos os 4):

1. **Achado** — fato observado, sem hipótese causal; com a contagem ou
   o nome do artefato.
2. **Evidência** — o que sustenta o fato: comando, path, query, link,
   payload, log, screenshot ou outra referência verificável. Registrar
   caminho reproduzível quando houver; reprodução determinística NÃO é
   obrigatória — mas ausência de qualquer evidência exige explicitação.
3. **Por que importa** — consequência/risco se ficar sem disposição.
4. **Disposição** — UMA e somente uma, satisfazendo o requisito da
   variante:
   - `resolver agora` → referência à resolução (PR/commit/edição);
   - `vira tarefa` → referência à issue criada (no formato v2);
   - `deferimento consciente` → rationale + condição objetiva de
     revisita (trigger) + referência ao artefato canônico portador,
     quando aplicável (o Achado não escolhe por si só qual artefato de
     governança deve existir);
   - `inerte` → rationale explícito.

   Disposição sem o requisito da variante = achado ainda aberto.

## Auto-checagem antes de salvar (espelho do C5)

O C5 (vigilância noturna, camada 2) valida contra o payload cru da API,
não contra o render (RT-FMT-11). Antes de `save_issue`, verifique você
mesmo:

- [ ] Núcleo presente (Objetivo · Outputs · Feito quando).
- [ ] Todo campo estrutural na representação canônica (`**Campo:**`) —
      ponto, heading ou sinônimo não contam.
- [ ] Todo marcador de output bem-formado, com o path entre crases:

      ```text
      - [ ] `<path>` *(create|update)*
      ```
- [ ] Output fora do mesh-spec ⇒ label `repo:` presente e coerente +
      effectProofs no Feito quando.
- [ ] Toca path governado (`schemas/` / `design-principles` /
      `structural-checks` / política de CI) ⇒ classificação = semântica
      + ADR previsto no mesmo commit.
- [ ] Tarefa que escreve em repo ⇒ camada de escrita (4–8) presente.
- [ ] Nenhuma linha "Estado:" no corpo.
- [ ] Achado ⇒ Triagem + label `achado` + Achado/Evidência/Por que
      importa/Disposição presentes + disposição válida para a variante
      escolhida.

## Limites desta skill

- Ela governa AUTORIA de issues; não substitui o regime gated dos repos
  nem o C5 (enforcement noturno) — as projeções de autoria e o C5
  derivam das fontes canônicas correspondentes.
- Variante ainda não fechada na fonte: o detalhamento T2 (cross-repo
  + tabela de effectProofs). Onde a fonte for omissa, não improvise:
  pergunte ao founder e registre a resposta na fonte canônica primeiro.
