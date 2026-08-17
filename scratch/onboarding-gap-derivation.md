# Derivação dos vazios de onboarding — o que a operação pressupõe e nenhum command cria

**Escopo:** leitura e análise de `contexts/*/domain-model.cue` (13 BCs, 13.531 linhas), `contexts/*/api.yaml` (6 BCs), `strategic/domain-stories/buyer-procurement-journey.cue`, `domain/stakeholder-map.cue`.
**Base:** `main @ 13ce2ba` (merge do PR #251).
**Regra aplicada:** toda afirmação carrega `arquivo:linha`. Nada de modelagem proposta — só o que está no disco e o que falta nele.
**Não lido por instrução:** `governance/build-time/self-reviews/**`.

---

## Passo 1 — Extração

### Inventário de base (o que existe)

**16 aggregates em 13 BCs.** Todos os `code: "agg-*"` do repo:

| BC | Aggregates | Linha |
|---|---|---|
| bdg | agg-cost-center | `contexts/bdg/domain-model.cue:554` |
| bkr | agg-settlement-attempt | `contexts/bkr/domain-model.cue:1166` |
| cmt | agg-commitment | `contexts/cmt/domain-model.cue:551` |
| ctr | agg-contract-terms | `contexts/ctr/domain-model.cue:349` |
| dlv | agg-verification | `contexts/dlv/domain-model.cue:523` |
| fce | agg-payment | `contexts/fce/domain-model.cue:737` |
| idc | agg-organizational-identity · agg-evidence-cryptography | `contexts/idc/domain-model.cue:282` · `:360` |
| inv | agg-invoice | `contexts/inv/domain-model.cue:326` |
| npm | agg-participant | `contexts/npm/domain-model.cue:254` |
| p2p | agg-purchase-order · agg-purchase-requisition | `contexts/p2p/domain-model.cue:895` · `:1120` |
| rew | agg-risk-evaluation · agg-risk-alert · agg-risk-model · agg-risk-policy | `contexts/rew/domain-model.cue:1224` · `:1477` · `:1580` · `:1668` |
| ssc | agg-sourcing-process | `contexts/ssc/domain-model.cue:1176` |
| drc, scf | (só canvas — sem domain-model) | `contexts/drc/canvas.cue:20` · `contexts/scf/canvas.cue:25` |

**Superfície HTTP existe em 6 dos 13 BCs.** Têm `api.yaml`: cmt, dlv, fce, npm, p2p, ssc. **Não têm:** bdg, bkr, ctr, idc, inv (só `async-api.yaml`), rew, drc, scf.

### Conjunto (a) — campos `*Ref` com identidade mantida em outro BC

Filtrei os 583 `*Ref` do repo separando campos de metamodelo (`valueObjectRef` 530×, `boundedContextRef` 21×, `aggregateRef` 12× — são o schema do domain-model, não dados de domínio) dos campos de domínio. Os campos de domínio cuja *description* declara identidade alheia:

| Campo | Onde | Declaração literal |
|---|---|---|
| `costCenterRef` | `contexts/p2p/domain-model.cue:176` | "identidade canônica vive no bdg agg-cost-center. Primitive ref cross-BC: p2p referencia, bdg mantém" |
| `costCenterRef` (repetições) | `contexts/p2p/domain-model.cue:534` · `:1146` | idem |
| `budgetStageRef` | `contexts/p2p/domain-model.cue:179-181` | "Primitive ref: etapa como conceito first-class bdg-side **não existe ainda**" |
| `categoryRef` → `vo-category-ref` | `contexts/p2p/domain-model.cue:813-821` | "taxonomia configurada externamente… P2P consome ref, **não define taxonomia**" |
| `categoryRef` → `vo-category-ref` | `contexts/ssc/domain-model.cue:879-887` | "taxonomia configurada externamente… SSC consome ref, **não define taxonomia**" |
| `supplierRef` → `vo-supplier-ref` | `contexts/p2p/domain-model.cue:805` | "NPM mantém identidade canônica e qualificação" |
| `sourcingDecisionRef` | `contexts/p2p/domain-model.cue:610` | "identidade canônica vive no ssc vo-sourcing-decision-id… p2p referencia, ssc mantém" |
| `claimedAuthorityRef` → `vo-authority-ref` | `contexts/p2p/domain-model.cue:780-788` | "P2P consume identidade SSC-mantida; SSC mantém canonicidade" |
| `coverageReservationRef` | `contexts/p2p/domain-model.cue:268` | "Primitive ref cross-BC" (reserva owned pelo bdg) |
| `requisitionRef` | `contexts/bdg/domain-model.cue:92` | "Primitive ref cross-BC: p2p mantém a identidade canônica" |
| `contractTermsRef` → `vo-contract-terms-ref` | `contexts/cmt/domain-model.cue:73` · `:94` · `:280` · `:473` | termos owned por CTR; validação sync fail-closed (`:275`) |
| `criteriaVersion` → `vo-criteria-version` | `contexts/dlv/domain-model.cue:439-450` | "Snapshot imutável hash-anchored de criteria **owned por CMT**"; constraint: "reference DEVE existir em CMT" |

### Conjunto (b) — invariantes que leem estado que o BC não produz

**12 blocos `dependsOnAggregateState` declarados** (a dependência está no disco):

| # | Invariante | Arquivo:linha | Lê | Via |
|---|---|---|---|---|
| 1 | inv-terms-reference-valid | `contexts/cmt/domain-model.cue:400` | ctr / agg-contract-terms | QueryContractTerms |
| 2 | inv-valid-participant-qualification | `contexts/ctr/domain-model.cue:233` | npm / agg-participant | QueryParticipantStatus |
| 3 | inv-supersession-ordering | `contexts/dlv/domain-model.cue:356` | intra-BC agg-verification | prj-evidence-lineage |
| 4 | inv-signature-requires-active-identity | `contexts/idc/domain-model.cue:116` | intra-BC agg-organizational-identity | projection |
| 5 | inv-approval-requires-identity-verification | `contexts/npm/domain-model.cue:139` | idc / agg-organizational-identity | QueryIdentityVerificationStatus |
| 6 | inv-purchase-order-requires-valid-authority | `contexts/p2p/domain-model.cue:678` | ssc / agg-sourcing-process | QuerySourcingDecision |
| 7 | inv-approval-requires-coverage-reservation | `contexts/p2p/domain-model.cue:717` | bdg / agg-cost-center | QueryBudgetApprovalStatus |
| 8 | inv-approval-amount-matches-winning-quotation | `contexts/p2p/domain-model.cue:731` | ssc / agg-sourcing-process | QueryQuotationMap |
| 9 | inv-emission-requires-approved-requisition | `contexts/p2p/domain-model.cue:745` | intra-BC agg-purchase-requisition | prj-pending-requisitions |
| 10 | inv-decision-from-structured-signals | `contexts/ssc/domain-model.cue:780` | npm / agg-participant | QueryParticipantStatus |
| 11 | inv-qualification-as-precondition | `contexts/ssc/domain-model.cue:799` | npm / agg-participant | QueryParticipantStatus |
| 12 | inv-competitive-pool-or-supervised-exception | `contexts/ssc/domain-model.cue:823` | npm / agg-participant | QueryParticipantStatus |

`rew` tem zero blocos — a única ocorrência da string é comentário de método (`contexts/rew/domain-model.cue:20`).

**5 invariantes/atos que leem estado não-produzido SEM declarar a dependência** — é aqui que o vazio aparece:

| Invariante / ato | Arquivo:linha | Lê o quê | Declaração da ausência |
|---|---|---|---|
| inv-alcada-respected | `contexts/bdg/domain-model.cue:375-378` | "Alçada do agente conforme **tabela vigente**" | `:378` — "a tabela de Alçadas vive como configuração externa fora do BDG BC… este invariant captura a regra de respeito **mas não modela o data**" |
| inv-fitness-rules-versioned-config | `contexts/ssc/domain-model.cue:833-836` | fitness rules versionadas por categoria | `:836` — "Shape e infraestrutura de configuração é openQuestion **oq-ssc-8**" (`contexts/ssc/canvas.cue:707-711`) |
| inv-evidence-class-conforms-taxonomy | `contexts/idc/domain-model.cue:135-138` | "schema da classe declarada na **taxonomia canônica de evidência**" | `:138` — "Em Phase 0 antes de **ten-004** resolver, sustentado por whitelist + escalation" |
| inv-requisition-completeness | `contexts/p2p/domain-model.cue:708-711` | "costCenterRef + budgetStageRef + categoryRef presentes **e válidos**" | nenhuma — não há `dependsOnAggregateState`, e não existe registro contra o qual "válido" se resolva |
| cmd-evaluate-verification | `contexts/dlv/domain-model.cue:239` | "criteriaVersion vigente (sync via **QueryCommitmentCriteria** Phase 0)" | dependência cross-BC ao CMT **não declarada** — o único bloco do dlv (`:356`) é intra-BC |

### Conjunto (c) — campos/invariantes/services marcados como config externa

| Item | Arquivo:linha | Marcador |
|---|---|---|
| `vo-cost-center-id` | `contexts/bdg/domain-model.cue:411-419` | "Identificador canônico… **configurado externamente**. Formato definido por configuração externa" |
| `agg-cost-center.limit` | `contexts/bdg/domain-model.cue:566-568` | "Limite **configurado externamente**; ajustes são supervisedDecisions (adjust-cost-center-limit)" |
| `agg-cost-center` (lifecycle) | `contexts/bdg/domain-model.cue:556` | "Lifecycle do Centro de Custo (criação, descontinuação) é **governance externa**… não modelado como state machine" |
| tabela de Alçadas | `contexts/bdg/domain-model.cue:378` · `contexts/bdg/glossary.cue:144-149` | "Configurada externamente em tabela vigente" |
| `vo-category-ref` (p2p/ssc) | `contexts/p2p/domain-model.cue:815` · `contexts/ssc/domain-model.cue:881` | "**taxonomia** configurada externamente" |
| fitness rules | `contexts/ssc/domain-model.cue:834` · `contexts/ssc/glossary.cue:141` | "Fitness Rules **Versionadas em Config Externa**"; "configuradas externamente por category manager" |
| `vo-fitness-rule-snapshot.content` | `contexts/ssc/domain-model.cue:966-975` | tipo `FitnessRuleContent` — "Pesos + thresholds + lógica de equalização (**shape em oq-ssc-8**)" |
| taxonomia de evidência | `contexts/idc/domain-model.cue:137` | "taxonomia canônica de evidência" |
| `vo-criteria-version` | `contexts/dlv/domain-model.cue:439-450` | "criteria owned por CMT"; "**versionado**" |
| `vo-regime-version` | `contexts/inv/domain-model.cue:290-296` | "regras fiscais externas (CFOP, alíquotas, retenções)… INV consome o identifier **resolvido externamente, NÃO o resolve nem o interpreta**" |
| `cancellationWindow` | `contexts/inv/domain-model.cue:126` · `:509` | "função pura **externa** ao domínio (regime parameter lookup); domínio usa, não define" |
| `agg-risk-model` / `agg-risk-policy` | `contexts/rew/domain-model.cue:1580` · `:1668` | "controle **versionado**" (`contexts/rew/domain-model.cue:52`) |

---

## Passos 2–4 — Teste do dono, degrau de custo e os dois gates

### Tabela principal

| # | Conceito | Onde é referenciado | Dono (aggregate) | Superfície (api.yaml) | Classificação | Degrau | Gate banco | Gate vertical | Nome vertical-neutro |
|---|---|---|---|---|---|---|---|---|---|
| **V1** | **Centro de Custo** (identidade) | `p2p:176`, `:534`, `:1146`; `p2p/api.yaml:460-464` | `bdg` agg-cost-center `bdg:554` | **nenhuma** — bdg sem api.yaml | **DONO SEM SUPERFÍCIE** (sem ato de criação sequer) | 3 | **PASSA** | PASSA | Centro de Custo |
| **V2** | **Limite do Centro de Custo** | `bdg:566-568`, `bdg:534`; `bdg/canvas.cue:341` | `bdg` agg-cost-center `bdg:554` | **nenhuma** | **DONO SEM SUPERFÍCIE** | 3 | **PASSA** | PASSA | Limite Orçamentário |
| **V3** | **Tabela de Alçadas** | `bdg:377-378`; `bdg/glossary.cue:144-149`; lida no portão `p2p:717` | **nenhum** | nenhuma | **SEM DONO** | 3 | **PASSA** | PASSA | Alçada (Limite de Autorização por Ator) |
| **V4** | **Categoria de Compra** | `p2p:813-821`, `ssc:879-887`, `p2p:708`, `ssc/glossary.cue:138-141`; `p2p/api.yaml:455-459` | **nenhum** (ambos os BCs declaram que não definem) | nenhuma | **SEM DONO** | 3 | **PASSA** | PASSA | Categoria de Compra |
| **V5** | **Etapa de orçamento** (`budgetStageRef`) | `p2p:179-181`, `:534-536`, `:1146-1148`, `:708`; `p2p/api.yaml:465-472` | **nenhum** — "não existe ainda" (`p2p:181`) | string livre exposta | **SEM CERIMÔNIA** | 3 | **AMBÍGUO** | **AMBÍGUO** | ver AMBÍGUOS A-1 |
| **V6** | **Fitness Rules por categoria** | `ssc:833-836`, `:966-975`, `:1546`; `ssc/canvas.cue:707-711` | **nenhum** | nenhuma | **SEM DONO** | 3 | **PASSA** | PASSA | Regras de Aptidão por Categoria |
| **V7** | **Identidade de usuário** (ator humano) | `adr-182:117-119`; `p2p:169-171`; `p2p/api.yaml:706-711` | **nenhum** — "aggregate de usuário é fatia futura do idc" | string nominal não-verificada | **SEM CERIMÔNIA** | 3 | **PASSA** | PASSA | Identidade de Ator Humano |
| **V8** | **Termos Contratuais** | `cmt:73`, `:94`, `:280`, `:393`, `:400` | `ctr` agg-contract-terms `ctr:349` | **nenhuma** — ctr sem api.yaml (cmds em `ctr:136`, `:154`) | **DONO SEM SUPERFÍCIE** | 1 | **PASSA** | PASSA | Termos Contratuais |
| **V9** | **Identidade Organizacional** | `npm:99`, `npm:139`; `context-map.cue:924-925` | `idc` agg-organizational-identity `idc:282` | **nenhuma** — idc sem api.yaml (cmd em `idc:76`) | **DONO SEM SUPERFÍCIE** | 1 | **PASSA** | PASSA | Identidade Organizacional |
| **V10** | **Taxonomia de classes de evidência** | `idc:135-138`; `ten-004` | **nenhum** | nenhuma | **SEM DONO** | 3 | REPROVA | PASSA (forma) | Taxonomia de Classes de Evidência |
| **V11** | **Critério de verificação** (`criteriaVersion`) | `dlv:439-450`, `:54`, `:85`, `:107`, `:239` | **nenhum** — dono reivindicado (CMT) não existe | nenhuma | **SEM DONO** | 3 | REPROVA | PASSA (forma) | Critério de Aceitação Versionado |
| **V12** | **Regime fiscal** (`regimeVersion`) | `inv:290-296`, `:126`, `:509` | **nenhum** | nenhuma (inv só tem async-api) | **SEM DONO** | 3 | **PASSA** | PASSA (jurisdicional) | Versão de Regime Fiscal |
| **V13** | **Risk Model / Risk Policy** | `rew:1580-1640`, `:1668-1740`, `rew:52` | `rew` agg-risk-model / agg-risk-policy | **nenhuma** — rew sem api.yaml | **DONO SEM SUPERFÍCIE** (draft inalcançável) | 3 | **PASSA** | PASSA | Modelo/Política de Risco Versionados |
| **C1** | *Fornecedor / Participante* (controle) | `p2p:805`, `ssc:889`, `ctr:233`, `ssc:799` | `npm` agg-participant `npm:254` | `/v1/npm/commands/register-participant` `npm/api.yaml:120` | **DONO E SUPERFÍCIE** | — | — | — | — |

C1 é o caso de controle: o único conceito pressuposto pela jornada que tem aggregate, ato de criação (`cmd-register-participant`, `npm:89`) **e** path HTTP. Todos os demais falham em pelo menos uma das três pernas.

### Justificativa do degrau, arquivo por arquivo

**V1 — Centro de Custo · Degrau 3.** O aggregate existe com campos (`limit`, `limitConfiguredAt`, `active` — `contexts/bdg/domain-model.cue:566-578`), mas `handlesCommands` lista exatamente quatro commands (`contexts/bdg/domain-model.cue:641-646`: approve / confirm / reject / release) e nenhum cria o Centro de Custo. O disco declara a exclusão: `contexts/bdg/domain-model.cue:556` — "Lifecycle do Centro de Custo (criação, descontinuação) é governance externa"; e `:675` — "Aggregate sem lifecycle (per tq-dmg-07)". Para criar seria preciso: **ato novo** (`cmd-create-cost-center` em `contexts/bdg/domain-model.cue` commands) + **estado novo** (bloco `lifecycle` no aggregate, hoje inexistente) + **evento** (o BC publica quatro events e nenhum de criação, `:648-653`) + **superfície nova** (`contexts/bdg/api.yaml` não existe — o arquivo inteiro precisaria nascer). É Degrau 3 por três dos quatro critérios.

**V2 — Limite · Degrau 3.** O campo existe (`contexts/bdg/domain-model.cue:566-568`), e o canvas nomeia a supervisedDecision `adjust-cost-center-limit` (`contexts/bdg/canvas.cue:341-343`), mas nenhum command a materializa em `contexts/bdg/domain-model.cue` — o vocabulário de governança está no canvas e o ato não está no domain-model. Ato novo → Degrau 3.

**V3 — Alçada · Degrau 3.** O caso mais explícito do repo. `contexts/bdg/domain-model.cue:378` diz textualmente: "value object próprio para faixa de Alçada **não é necessário** porque limites são consultados em runtime via API/configuration externa, não persistidos como state interno do agg-cost-center". Não há VO, não há campo, não há aggregate, não há command. Criar exige aggregate novo + ato novo + estado novo, e cruza BC na leitura (`contexts/p2p/domain-model.cue:717` — o portão do p2p depende de o bdg saber a alçada). Degrau 3.

**V4 — Categoria · Degrau 3.** Dois BCs declaram a mesma não-propriedade: `contexts/p2p/domain-model.cue:821` e `contexts/ssc/domain-model.cue:887` — ambos "consome ref, não define taxonomia". `contexts/ssc/glossary.cue:141` atribui a manutenção a um "category manager" que não existe no `domain/stakeholder-map.cue` (ver Passo 6). Criar exige aggregate novo em algum lar + ato novo + **dependência nova entre BCs** (quem quer que passe a definir vira upstream de p2p e ssc simultaneamente). Degrau 3 pelos três critérios.

**V5 — Etapa de orçamento · Degrau 3.** `contexts/p2p/domain-model.cue:181` admite: "etapa como conceito first-class bdg-side não existe ainda — formalização eventual acompanha o re-papel WI-153 ou fatia própria". O campo atravessa toda a cadeia como string livre (`contexts/p2p/api.yaml:465-472`: `type: string, minLength: 1`). Formalizar exige ato novo + estado novo + aresta nova p2p→(lar da etapa). Degrau 3. **Nota:** a ausência é decisão registrada do founder (WI-151, ecoada em `contexts/p2p/domain-model.cue:162` e no rationale do passo 1 da story, `strategic/domain-stories/buyer-procurement-journey.cue:30`) — é vazio deliberado, não descuido.

**V6 — Fitness Rules · Degrau 3.** O invariante existe e exige o dado (`contexts/ssc/domain-model.cue:834`), o VO de snapshot existe (`:966`), mas o tipo `FitnessRuleContent` está declarado sem shape: "(shape em oq-ssc-8)" (`:969`). A pergunta em aberto pede as três coisas de uma vez — `contexts/ssc/canvas.cue:708`: "Onde vivem fitness rules versionadas? Como configurar pesos/critérios por categoria? **Quem governa mudanças?**" Ato novo + estado novo + shape novo. Degrau 3.

**V7 — Identidade de usuário · Degrau 3.** `architecture/adrs/adr-182-identity-and-actor-model.cue:117-119` fixa o contrato e adia a materialização: "actorId (humano: identidade de usuário emitida sob o lar do idc — a modelagem do **aggregate de usuário é fatia futura do idc**, este ADR fixa o CONTRATO)". Busca global por `agg-user|agg-usuario|agg-actor|agg-person` em `contexts/`: zero resultados. Hoje o ator viaja como string nominal não-verificada — `contexts/p2p/api.yaml:706-711`: "requestedBy… atribuição nominal NÃO-verificada nesta borda até o ADR de auth (def-024)". O `def-024` está `resolved` (`architecture/deferred-decisions/def-024-api-yaml-auth-servers-pending-adr.cue:9-10`, resolvido pelo adr-182) — o que significa que a *decisão* fechou e a *materialização* não abriu. Aggregate novo + ato novo + estado novo. Degrau 3.

**V8 — Termos Contratuais · Degrau 1.** Único caso onde falta só a superfície: `cmd-register-contract-terms` (`contexts/ctr/domain-model.cue:136`) e `cmd-activate-contract-terms` (`:154`) existem e são completos em campos; o aggregate existe (`:349`); o que não existe é `contexts/ctr/api.yaml`. Escrever o arquivo não muda significado, não cria evento, não cruza BC. Degrau 1.

**V9 — Identidade Organizacional · Degrau 1.** Mesma forma: `cmd-verify-organization-identity` existe (`contexts/idc/domain-model.cue:76`) e é declarado "Pré-condição de onboarding via NPM" (`:79`); o aggregate existe (`:282`); falta `contexts/idc/api.yaml`. Degrau 1.

**V10 — Taxonomia de evidência · Degrau 3.** O invariante existe e é declaradamente inaplicável até a taxonomia existir (`contexts/idc/domain-model.cue:138`: "sustentado por whitelist + escalation" até `ten-004`). Conceito novo inteiro. Degrau 3.

**V11 — Critério de verificação · Degrau 3.** O dlv cita CMT como dono em três lugares (`contexts/dlv/domain-model.cue:54` BND-2 "criteriaVersion DEVE referenciar CMT existing"; `:441` "criteria owned por CMT"; `:447` constraint "reference DEVE existir em CMT"), mas `grep -c "criteri" contexts/cmt/domain-model.cue` = **0**. O CMT não tem conceito de criteria: nem VO, nem campo, nem command, nem evento. A query `QueryCommitmentCriteria` aparece 15× no repo — todas em `contexts/dlv/**`, nenhuma em `contexts/cmt/**`. O dono é reivindicado por um BC e desconhecido pelo outro. Aggregate novo no cmt + ato novo + query-surface nova + aresta cmt→dlv declarada. Degrau 3.

**V12 — Regime fiscal · Degrau 3.** `contexts/inv/domain-model.cue:292`: "INV consome o identifier resolvido externamente, NÃO o resolve nem o interpreta". A função `cancellationWindow(regimeVersion)` é declarada externa em dois pontos (`:126`, `:509`, com o segundo admitindo "Phase 0 lookup tabela declarativa simples"). Conceito novo. Degrau 3.

**V13 — Risk Model / Policy · Degrau 3 (superfície é Degrau 1).** Os dois aggregates têm `initialState: "draft"` (`contexts/rew/domain-model.cue:1624`, `:1722`), mas as únicas transições declaradas são `draft→active` (`cmd-activate-risk-model` / `cmd-activate-risk-policy`) e `active→deprecated`. **Nenhum command cria o draft** — o estado inicial é inalcançável pelo modelo. Os dez commands do rew (`contexts/rew/domain-model.cue:423-570`) não incluem registro/criação de modelo ou política. Falta ato novo → Degrau 3; a superfície ausente (rew sem api.yaml) seria Degrau 1 isolada.

### Gate do banco — vereditos

| Vazio | Veredito | Razão |
|---|---|---|
| V1 Centro de Custo | **PASSA** | É a unidade contra a qual todo comprometimento é registrado (`contexts/bdg/domain-model.cue:554`) — sem ela não há estrutura de autorização de gasto, só um valor solto. |
| V2 Limite | **PASSA** | O teto que define Saldo Disponível = Limite − Σ ativos (`contexts/bdg/domain-model.cue:536`); sem teto o gate de cobertura aprova tudo. |
| V3 Alçada | **PASSA** | É literalmente segregação de função por valor: quem pode autorizar quanto (`contexts/bdg/glossary.cue:147`), e o antiterm distingue de permissão técnica (`:150-152`). |
| V4 Categoria | **PASSA** | Eixo sobre o qual roda a detecção de fracionamento — evasão de alçada por splitting (`contexts/bdg/canvas.cue:406-407`, oq-bdg-1; `contexts/ssc/agents/ssc-primary-agent.cue:365`). Sem categoria, o vetor de burla da autorização fica invisível. |
| V5 Etapa | **AMBÍGUO** | ver AMBÍGUOS A-1. |
| V6 Fitness Rules | **PASSA** | São o que torna a decisão de sourcing reconstituível (`contexts/ssc/domain-model.cue:836`: "sem snapshot versionado, audit não consegue reconstituir como decisão foi tomada"), e é a cotação vencedora dessa decisão que o 2º braço do portão usa para provar a procedência do valor aprovado (`contexts/p2p/domain-model.cue:731-742`). Preço sem procedência é crédito às cegas. |
| V7 Identidade de usuário | **PASSA** | A separação preparador (sh-08) × aprovador (sh-09) é declarada como a segregação que o passo 9 exigia (`domain/stakeholder-map.cue:472`); sem identidade de ator ela não é verificável — é apenas dois nomes digitados no mesmo formulário. |
| V8 Termos Contratuais | **PASSA** | Lastro jurídico: "compromisso sem lastro contratual é risco jurídico" (`contexts/cmt/domain-model.cue:399`), validação fail-closed no propose (`:275`). |
| V9 Identidade Organizacional | **PASSA** | KYC/AML — pré-condição regulatória de qualificação (`contexts/npm/domain-model.cue:99`; `contexts/idc/domain-model.cue:105-107` inv-source-authority-required cita diligência SCD/Bacen). |
| V10 Taxonomia de evidência | **REPROVA** | Governa o schema da evidência de entrega — matéria de medição/comprovação de execução, não de autorização de gasto. |
| V11 Critério de verificação | **REPROVA** | É o critério de aceite da entrega (`contexts/dlv/domain-model.cue:239`) — medição e avanço, fora do frame de originação do crédito. |
| V12 Regime fiscal | **PASSA** | Determina a validade fiscal da Invoice, e a Invoice materializa o direito creditório que o SCF origina (`contexts/inv/domain-model.cue:80`). Lastro inválido = crédito sobre nada. |
| V13 Risk Model / Policy | **PASSA** | É o eixo de precificação de risco em sentido literal — e a ativação sem authority é a classe de erro que o próprio modelo nomeia (`contexts/rew/domain-model.cue:513`: "unauthorized model activation causing decision drift"). |

### Gate da vertical — vereditos

| Vazio | Sobrevive? | Nome vertical-neutro | Agro | Energia | Varejo |
|---|---|---|---|---|---|
| V1 Centro de Custo | **Sim** | Centro de Custo | talhão / safra / fazenda | ativo / usina / parque | loja / CD / filial |
| V2 Limite | **Sim** | Limite Orçamentário | orçamento de safra | CAPEX/OPEX do ativo | orçamento de compras da loja |
| V3 Alçada | **Sim** | Alçada (Limite de Autorização por Ator) | alçada do gerente de fazenda | alçada do gerente de ativo | alçada do gerente de loja / comprador de categoria |
| V4 Categoria | **Sim** | Categoria de Compra | insumos, defensivos, fertilizantes, sementes | equipamentos, O&M, combustível | mercadoria para revenda, não-mercadoria |
| V5 Etapa | **AMBÍGUO** | ver AMBÍGUOS A-1 | ciclo/safra | fase do projeto | temporada/campanha |
| V6 Fitness Rules | **Sim** | Regras de Aptidão por Categoria | idem (pesos por categoria de insumo) | idem | idem |
| V7 Identidade de usuário | **Sim** | Identidade de Ator Humano | universal | universal | universal |
| V8 Termos Contratuais | **Sim** | Termos Contratuais | contrato de fornecimento de insumo | PPA / contrato de O&M | acordo comercial / verba |
| V9 Identidade Organizacional | **Sim** | Identidade Organizacional | universal (CNPJ + registro) | universal | universal |
| V10 Taxonomia de evidência | **Sim em forma** | Taxonomia de Classes de Evidência | as **classes** são verticais (laudo de classificação) | classes verticais (medição de geração) | classes verticais (nota de conferência) |
| V11 Critério de verificação | **Sim em forma** | Critério de Aceitação Versionado | laudo de classificação de grão | medição de geração | conferência de recebimento |
| V12 Regime fiscal | **Sim** | Versão de Regime Fiscal | universal — a variação é **jurisdicional**, não vertical | idem | idem |
| V13 Risk Model / Policy | **Sim** | Modelo/Política de Risco Versionados | universal | universal | universal |

Nenhum vazio foi marcado **INSTÂNCIA** de forma limpa. V5 é o único candidato, e a decisão depende de qual leitura da própria description se adota — por isso está em AMBÍGUOS, não decidido aqui.

---

## Passo 5 — Grafo de dependência de criação

Apenas os vazios que **passaram no gate do banco** (V1, V2, V3, V4, V6, V7, V8, V9, V12, V13). Ordenação por dependência de criação, não por degrau. C1 (Participante) aparece como nó porque é aresta intermediária obrigatória, embora não seja vazio.

```
CAMADA 0  (nenhum pré-requisito entre os vazios)
  ├── V9  Identidade Organizacional
  ├── V4  Categoria de Compra
  ├── V1  Centro de Custo
  ├── V3  Tabela de Alçadas
  ├── V7  Identidade de Ator Humano
  ├── V12 Regime Fiscal
  └── V13 Risk Model / Risk Policy

CAMADA 1
  ├── C1  Participante qualificado   ← V9
  ├── V2  Limite do Centro de Custo  ← V1
  └── V6  Fitness Rules por categoria ← V4

CAMADA 2
  └── V8  Termos Contratuais         ← C1

CAMADA 3  (a operação — fora do escopo de onboarding)
  ├── Requisição submetida           ← V1, V4, V5, V7
  ├── RFQ aberta                     ← V4, C1
  ├── Decisão de sourcing            ← V6, C1
  ├── Aprovação (portão duplo)       ← V1, V2, V3, V7 + decisão de sourcing
  ├── Pedido de compra               ← requisição aprovada + decisão de sourcing
  └── Compromisso                    ← V8 + pedido emitido
```

### Arestas, uma a uma

| Aresta | Evidência |
|---|---|
| V9 → C1 | `contexts/npm/domain-model.cue:99` — "cmd-approve-qualification… Pré-condição: query a IDC confirma verificação de identidade"; bloco em `:139` (dependsOnAggregateState idc/agg-organizational-identity). Reforço estratégico: `strategic/context-map.cue:924-925` — "Identidade verificável é pré-condição de onboarding — NPM não qualifica sem identidade". |
| C1 → V8 | `contexts/ctr/domain-model.cue:231` — "Registro de termos contratuais só é aceito se todas as partes referenciadas existem e estão **qualificadas em NPM**"; bloco em `:233`. |
| C1 → RFQ | `contexts/ssc/domain-model.cue:797` — "Nenhum fornecedor entra em RFQ sem status eligible-for-sourcing em NPM"; bloco em `:799`. |
| V1 → V2 | `limit` é campo do `agg-cost-center` (`contexts/bdg/domain-model.cue:566-568`) — não existe Limite sem Centro de Custo que o carregue. |
| V4 → V6 | `contexts/ssc/glossary.cue:141` — "**Cada categoria tem fitness rules vigentes próprias** (pesos, critérios, thresholds) configuradas externamente por category manager". A regra é segmentada por categoria; sem categoria não há chave de segmentação. |
| V4 → Requisição | `contexts/p2p/domain-model.cue:710` — inv-requisition-completeness exige `categoryRef` presente e válido para o roteamento. |
| V4 → RFQ | `contexts/ssc/domain-model.cue:507` — cmd-open-rfq abre "para a categoria"; `strategic/domain-stories/buyer-procurement-journey.cue:74` cita `term-categoria-de-compra` no passo 5. |
| V1 → Requisição | `contexts/p2p/domain-model.cue:710` — exige `costCenterRef` presente e válido. |
| V1 + V2 → Aprovação | `contexts/p2p/domain-model.cue:715-717` — inv-approval-requires-coverage-reservation: "EXIGE reserva de cobertura CONFIRMADA… Saldo Disponível suficiente no Centro de Custo". Saldo = Limite − Σ ativos (`contexts/bdg/domain-model.cue:536`). |
| V3 → Aprovação | `contexts/bdg/domain-model.cue:367` — "(2) valor está dentro da **Alçada** do ator que autoriza. Falha em qualquer verificação bloqueia a reserva"; `:377` inv-alcada-respected. |
| V6 → Decisão de sourcing | `contexts/ssc/domain-model.cue:778` — "Toda decisão emitida… é resultado da aplicação de **fitness rules versionadas** (vo-fitness-rule-snapshot) sobre fitnessSignals estruturados". |
| V7 → Requisição / Aprovação | `contexts/p2p/domain-model.cue:169-171` (`requestedBy`), `:614` (`rejectedBy` — "Gestor cuja Alçada cobre o valor"); `architecture/adrs/adr-182-identity-and-actor-model.cue:115-123` — todo ato tem ator estruturado de 4 dimensões, e `actorId` humano depende do aggregate de usuário inexistente. |
| V8 → Compromisso | `contexts/cmt/domain-model.cue:397` — "Proposta de compromisso só é aceita se os termos contratuais referenciados existem e estão vigentes em CTR"; `:275` — validação "sync em propose-time e **fail-closed**". |
| V12 → Invoice | `contexts/inv/domain-model.cue:292` — regimeVersion é atributo obrigatório declarando qual versão de regime vigia na emissão. |
| V13 (sem aresta de entrada) | `contexts/rew/domain-model.cue:1583` — "Aggregate de model versioning. **Independente** de RiskPolicy (inv-rew-model-policy-independence)"; nenhum bloco `dependsOnAggregateState` no rew. |

**Leitura do grafo.** A camada 0 tem sete nós e nenhum deles depende de outro — todos podem ser criados em paralelo. O caminho crítico mais longo é `V9 → C1 → V8` (três saltos). O gargalo real não é profundidade, é largura: sete conceitos precisam existir antes de qualquer coisa na jornada rodar, e nenhum dos sete tem ato de criação hoje.

---

## Passo 6 — Cobertura

### 6.1 — Refs citadas nos `workItem` da `ds-buyer-procurement-journey`

Todas as refs dos dez steps (`strategic/domain-stories/buyer-procurement-journey.cue:22-135`), com a checagem "existe ato de criação no repo?":

| Step | Ref | Tipo | Ato de criação | Onde |
|---|---|---|---|---|
| 1 | `term-originadora-de-demanda` | term | ✅ parcial | `cmd-register-participant` `npm:89` cria a organização; a *posição* originadora é relacional (adr-172) |
| 2 | `cmd-submit-purchase-requisition` | command | ✅ | `p2p:514`; exposto `p2p/api.yaml:189` |
| 2 | `evt-purchase-requisition-submitted` | event | ✅ | `p2p:155` |
| 2 | `term-requisitante` | term | ❌ | `p2p/glossary.cue:278-284` — "Role operacional… Phase 0 absorbed em sh-01". Nenhum ato cria a pessoa (V7) |
| 3 | `cmd-triage-requisition` | command | ✅ | `p2p:551`; exposto `p2p/api.yaml:227` |
| 3 | `evt-purchase-requisition-triaged` | event | ✅ | `p2p:200` |
| 3 | `prj-pending-requisitions` / `qry-pending-requisitions` | read model | ✅ derivado | exposto `p2p/api.yaml:48` |
| 3 | `term-comprador` | term | ❌ | `p2p/glossary.cue:258-264` — "Phase 0 absorbed em sh-01". Nenhum ato cria a pessoa (V7) |
| 4 | `prj-participant-status-view` / `qry-participant-status` | read model | ✅ | exposto `npm/api.yaml:46` |
| 4 | `term-qualificacao` | term | ✅ | `cmd-approve-qualification` `npm:99`; exposto `npm/api.yaml:245` |
| 4 | `term-status-de-participante` | term | ✅ | `cmd-register-participant` + lifecycle `npm:333` |
| 5 | `cmd-open-rfq` | command | ✅ | `ssc:504`; exposto `ssc/api.yaml:141` |
| 5 | `evt-rfq-opened` | event | ✅ | emitido por cmd-open-rfq (`ssc:1450`) |
| 5 | `term-rfq` | term | ✅ | idem |
| 5 | **`term-categoria-de-compra`** | term | ❌ | `ssc/glossary.cue:138-141`; `ssc:887` + `p2p:821` — ambos "consome ref, não define taxonomia" (**V4**) |
| 6 | `cmd-submit-quotation` | command | ✅ | `ssc:546`; exposto `ssc/api.yaml:184` |
| 6 | `evt-quotation-submitted` | event | ✅ | `ssc` (WI-152) |
| 7 | `prj-quotation-map` / `qry-quotation-map` | read model | ✅ | `ssc:1536`; exposto `ssc/api.yaml:91` |
| 7 | `term-equalizacao-tco` | term | ✅ derivado | `ssc:1536` — derivação determinística das fitness rules (depende de **V6**) |
| 7 | `term-mapa-de-cotacoes` | term | ✅ | `prj-quotation-map` |
| 8 | `cmd-propose-counter-terms` / `cmd-revise-quotation` / `cmd-decline-counter-terms` | commands | ✅ | `ssc:605` · `:628` · `:671`; expostos `ssc/api.yaml:234` · `:282` · `:335` |
| 8 | `evt-counter-terms-proposed` / `evt-quotation-revised` / `evt-counter-terms-declined` | events | ✅ | WI-161 |
| 8 | `term-contraproposta` / `term-rodada-de-negociacao` / `term-condicoes-de-pagamento` / `term-entregas-programadas` | terms | ✅ | materializados pelos 3 commands; `vo-payment-terms` `ssc:1114` |
| 9 | `cmd-make-one-shot-sourcing-decision` | command | ✅ | `ssc:695`; exposto `ssc/api.yaml:381` |
| 9 | `evt-sourcing-decision-made` | event | ✅ | idem |
| 9 | `term-sourcing-decision` / `term-decision-rationale` | terms | ✅ | `vo-decision-rationale` `ssc:984` |
| 10 | `cmd-emit-purchase-order` | command | ✅ | `p2p:454`; exposto `p2p/api.yaml:327` |
| 10 | `evt-purchase-order-emitted` | event | ✅ | `p2p:895` emitsEvents |
| 10 | `prj-purchase-orders` | read model | ✅ | exposto `p2p/api.yaml:101` |
| 10 | `term-purchase-order` / `term-sourcing-authority` | terms | ✅ | produzidos pela emissão / pela decisão |

**Refs sem ato de criação — o escopo mínimo da story de onboarding:**

1. **`term-categoria-de-compra`** (V4) — passo 5.
2. **`term-requisitante`** (V7) — passo 2.
3. **`term-comprador`** (V7) — passo 3.

**Ressalva importante sobre esta lista.** Os `workItem` **sub-representam** o que a jornada pressupõe. O passo 2 descreve em prosa "estruturar a Requisição de Compra — **Centro de Custo, etapa do orçamento**, categoria e escopo" (`strategic/domain-stories/buyer-procurement-journey.cue:35`) e o passo 9 fala em "aprova no sistema" sob Alçada (`:114`, com o rationale em `:122` citando o Gate de Cobertura "Saldo Disponível + Alçada") — mas **nenhum dos dois passos cita `term-centro-de-custo`, `term-alcada` ou etapa de orçamento nos `termRefs`**. V1, V2, V3 e V5 são pressupostos da jornada que a própria story não indexa. Lidos só pelos refs, esses quatro vazios ficam invisíveis; lidos pela prosa dos steps e pelos invariantes que os steps disparam (`p2p:710`, `p2p:717`, `bdg:367`), aparecem inteiros.

### 6.2 — `domain/stakeholder-map.cue`: existe ator cuja função seja CONFIGURAR?

**Não. Declaro a ausência.**

O mapa tem nove atores:

| Code | Nome | Category | Função | Linha |
|---|---|---|---|---|
| sh-01 | Construtora | network-participant | opera (originadora de demanda / tomadora) | `domain/stakeholder-map.cue:41-43` |
| sh-02 | Fornecedor | network-participant | opera (cota, entrega) | `:98-99` |
| sh-03 | Instituição financeira parceira | financial-institution | opera (financia) | `:155-156` |
| sh-04 | Bacen | government-authority | regula | `:212-213` |
| sh-05 | Agente de IA Mesh | platform-operator | **opera** — "executa operações aprovadas por gates" | `:249-252` |
| sh-06 | Adversário econômico | adversarial-actor-class | ataca | `:306-307` |
| sh-07 | Engenheiro requisitante | network-participant | opera (declara demanda) | `:374-376` |
| sh-08 | Comprador | network-participant | opera (tria, cota, negocia, converte) | `:413-415` |
| sh-09 | Gestor aprovador | network-participant | **decide** (aprova por Alçada) | `:470-472` |

Nenhuma `category` é de configuração. sh-05 é o mais próximo e é explicitamente *operador*: "Agente autônomo que **opera** o sistema dentro de autonomy envelopes e gates determinísticos — o operador primário da plataforma" (`domain/stakeholder-map.cue:252`). sh-09 é o único que decide em vez de executar, mas decide **sobre uma operação** (aprovar uma compra), não sobre parâmetros do sistema.

Três evidências independentes de que a lacuna é estrutural e já foi notada:

- **O "category manager" existe em prosa e não no mapa.** `contexts/ssc/glossary.cue:141` atribui a manutenção das fitness rules a "category manager"; `contexts/ssc/agents/ssc-primary-agent.cue` o cita 7× como quem decide abrir RFQ, declara o `decisionType` e muda a estratégia (`:151`, `:176`, `:190`, `:301`, `:313`, `:446`, `:518`), e o mapeia a **sh-01** — a *organização*, não uma persona. É um papel de configuração real que não tem archetype.
- **A "governance financeira da organização operadora" mantém a tabela de Alçadas** (`contexts/bdg/domain-model.cue:378`) — outro configurador nomeado em prosa, sem entry no mapa.
- **`ten-005`** já registrou a ausência de um operador de plataforma distinto (`architecture/tension-log/ten-005-platform-operator-not-modeled.cue:8`), com status `accepted` e a ressalva explícita de que "reflete apenas que o trade-off é tolerável **enquanto founder = operador**, não que a lacuna seja arquiteturalmente benigna" (`:24-26`). O texto lista cinco atores (sh-01..sh-05) — foi escrito antes do WI-157 que adicionou sh-07..sh-09.

**Consequência direta.** Todos os treze vazios da tabela principal são dados que alguém precisa criar antes de qualquer operação, e o modelo não tem nenhum ator a quem atribuir esse ato. O termo "onboarding" aparece 9× no repo (`contexts/idc/domain-model.cue:79`, `contexts/npm/domain-model.cue:15`, `:376`, `:380`, `:446`, `strategic/context-map.cue:78`, `:152`, `:924`, `:925`) e em **todas** as ocorrências significa onboarding de *participante* (empresa fornecedora/compradora). Não há uma única ocorrência que signifique configuração da organização compradora. A camada de configuração não é um vazio dentro do modelo — é uma camada que o modelo ainda não nomeia.

---

## AMBÍGUOS

### A-1 — `budgetStageRef` (V5): "etapa do cronograma/orçamento"

A description usa uma barra que carrega duas leituras incompatíveis, e as duas mudam o veredito dos dois gates. Texto integral em `contexts/p2p/domain-model.cue:181`: *"Etapa do **cronograma/orçamento** que origina a demanda"*.

**Leitura 1 — cronograma físico.** Sustentada por: `strategic/domain-stories/buyer-procurement-journey.cue:24` ("identifica pelo **cronograma físico** o que as próximas etapas vão exigir"); `contexts/p2p/api.yaml:470-472` ("a fonte real da informação é o **cronograma físico observado no canteiro**"); `domain/stakeholder-map.cue:376` ("identifica pelo cronograma físico"). Sob esta leitura: **gate do banco REPROVA** (é cronograma físico, critério de reprovação nomeado) e **gate da vertical marca INSTÂNCIA** — a EAP/WBS de obra é específica de construção civil; o conceito genérico que a conteria seria *Unidade de Origem da Demanda*.

**Leitura 2 — etapa orçamentária.** Sustentada por: o nome do campo (`budgetStageRef`, não `scheduleStageRef`); a colocação do concerto — o campo viaja ao lado de `costCenterRef` na mesma tripla de completude (`contexts/p2p/domain-model.cue:710`); e a projeção de morada declarada, que é do lado **bdg**, não de um BC de cronograma: "etapa como conceito first-class **bdg-side** não existe ainda — formalização eventual acompanha o re-papel WI-153" (`:181`). Sob esta leitura: **gate do banco PASSA** (é subdivisão da estrutura orçamentária, mesma família de V1/V2) e **gate da vertical PASSA** — nome vertical-neutro *Fase Orçamentária*, com instâncias: agro = ciclo/safra; energia = fase do projeto; varejo = temporada/campanha.

Não escolho. A decisão de qual leitura vale é semântica e pertence ao founder — e determina se V5 entra ou sai do grafo de dependência do Passo 5.

### A-2 — Dono do `criteriaVersion` (V11): reivindicado vs. inexistente

O dlv afirma três vezes que o CMT é dono (`contexts/dlv/domain-model.cue:54`, `:441`, `:447`) e o CMT tem zero ocorrências de "criteri" no domain-model. Duas leituras:

**Leitura 1 — dívida de materialização.** A decisão de fronteira está tomada (o CMT *é* o dono, per BND-2 anti-criteria-inference) e falta materializar o conceito no `contexts/cmt/domain-model.cue`. Classificação: **SEM DONO** hoje, com destino já decidido; a criação seria fatia do cmt.

**Leitura 2 — fronteira ainda não resolvida.** "criteria owned por CMT" é premissa de trabalho do dlv, não decisão ratificada por ADR do lado do cmt — nenhum artefato do cmt a ecoa, e `QueryCommitmentCriteria` não aparece em nenhum arquivo de `contexts/cmt/**` (as 15 ocorrências estão todas em `contexts/dlv/**`). Classificação: **SEM DONO** e sem destino decidido; a escolha do lar é decisão aberta.

A diferença prática é grande: sob a leitura 1 o trabalho é execução; sob a 2, é decisão de fronteira que precisa de ADR antes de qualquer materialização.

### A-3 — Classificação de V1 e V13: "DONO SEM SUPERFÍCIE" ou "SEM CERIMÔNIA"?

Os dois casos têm aggregate declarado e nenhum ato que o crie: `agg-cost-center` (`contexts/bdg/domain-model.cue:554`, `handlesCommands` em `:641-646`) e `agg-risk-model`/`agg-risk-policy` (`contexts/rew/domain-model.cue:1624`, `:1722` — `initialState: "draft"` sem transição de entrada).

**Leitura 1 — DONO SEM SUPERFÍCIE.** O aggregate existe e mantém a identidade; falta o path no api.yaml. É a classificação literal do critério do Passo 2.

**Leitura 2 — SEM CERIMÔNIA.** Um aggregate cujo estado inicial nenhum command alcança não "mantém" identidade em sentido operacional — mantém uma forma. O dado real que atravessa os BCs continua sendo string livre (`contexts/p2p/api.yaml:460-464`: `CostCenterRef: type: string, minLength: 1`), sem enum e sem validação contra registro nenhum.

Adotei a Leitura 1 na tabela por ser a leitura literal do critério, e registrei "sem ato de criação sequer" na célula. A Leitura 2 é a que casa com o degrau atribuído (3, não 1) — as duas classificações discordam entre si sob a Leitura 1 e concordam sob a Leitura 2.

---

## Nota de método

- Números de linha conferidos contra `main @ 13ce2ba`.
- Contagens verificadas por `grep -c`: `dependsOnAggregateState` = 12 blocos reais (as ocorrências extras em p2p:677/701/1584 e ssc:779/798/822/1622 são rationale ou prosa); "criteri" em `contexts/cmt/domain-model.cue` = 0; `agg-user|agg-usuario|agg-actor|agg-person` em `contexts/` = 0.
- Não propus modelagem, naming de artefato, nem lar para nenhum vazio. Onde a leitura do disco admitia mais de uma interpretação, listei as duas em AMBÍGUOS em vez de escolher.
- Vigilância de defs na abertura da sessão: 0 de 86 triggers disparados; 3 defs em `triggered` STALE (def-013, def-029, def-035) — visibilidade, sem trava.
