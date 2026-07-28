// subagent-drafted (disp-010, founder-approved nesta fatia)

package production_guides

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// frontend-codegen-contract.cue — Production guide para o contrato de
// codegen spec→frontend-runtime.
//
// Schema alvo: #FrontendCodegenContract (architecture/artifact-schemas/
// frontend-codegen-contract.cue — nasce na MESMA fatia deste guide;
// promoção per adr-180, gatilho adr-178 D3, conteúdo obrigatório per
// mandato adr-179). Instância singleton vive em governance/build-time/
// frontend-codegen-contract.cue (lar histórico preservado na promoção,
// P0/adr-180). Autoria típica via este guide é EDIÇÃO da instância
// (nova família de superfície, nova action, nova read surface) — o
// guide cobre a migração inicial e as edições subsequentes.
//
// O coração do schema alvo é enforcement POR SHAPE (exclusão mútua
// action-bearing/read-only; slots do adr-179 por construção;
// movesMoney⇒approvalAsConfirmation; net-new⇒justificativa+migração;
// canvas-backed⇒hand-grandfathered): muito do que PGs de outros tipos
// vigiam por processo aqui é rejeitado por cue vet. Este guide guarda
// o que o shape NÃO alcança: substância dos slots, fidelidade das
// classificações (kind, movesMoney) contra o domínio, demonstração do
// não-padrão net-new (adr-178 dec 4) e contenção do grandfathering
// (adr-180 dec 3).
//
// Convenção: tq-fcg-NN para critérios deste guide (abreviação fixada
// pela fatia). Legend em architecture/artifact-schemas/
// quality-criteria.cue atualizada no mesmo commit — ação da fatia.

frontendCodegenContractGuide: artifact_schemas.#ProductionGuide & {

	_schema: {
		location: {
			canonicalPathRegex: "^architecture/production-guides/frontend-codegen-contract\\.cue$"
			fileNameRegex:      "^frontend-codegen-contract\\.cue$"
			description:        "Production guide para autoria do contrato declarativo de codegen spec→frontend-runtime em mesh-spec."
			rationale:          "Schema #FrontendCodegenContract é instanciável (singleton); cascade ordering (adr-053 + adr-054 dec 13) exige PG antes de instância — este guide nasce na mesma fatia da promoção (adr-180) para que a própria migração da instância vigente já seja autorada sob guide."
			cardinality:        "singleton"
			allowNested:        false
		}
	}

	_qualityCriteria: {
		criteria: [{
			id:          "tq-fcg-01"
			description: "Guide força verificação por leitura de todo ref de domínio e substância específica dos 3 slots (anti-fabricação)"
			test:        "Process das sections family-classification e action-slots declara passos explícitos de Ler o domain-model do sourceModel e verificar a existência de cada id declarado (commandRef, returnsEvents, aggregateRef, valueObjects, events, lifecycleStates, queryRef) ANTES de declará-lo; e de aplicar o teste de substituição aos 3 slots (trocar o command por outro qualquer — texto que continua válido é placeholder). Hardening de processo sobre tq-fcc-01 do schema (já fail)."
			severity:    "fail"
			rationale:   "O shape garante presença de refs e slots; fabricação (id inexistente no domain-model, slot genérico reutilizável) é o vetor primário de degradação em authoring por agente — placeholder derrota o mandato adr-179 tanto quanto ausência."
		}, {
			id:          "tq-fcg-02"
			description: "Guide força demonstração de fonte-fora-do-sistema e def de migração existente para origem net-new"
			test:        "collectFromFounder explicita a demonstração net-new como input do founder (fato de produto que o agente não atesta sozinho); process da section action-slots exige verificar que netNewJustification DEMONSTRA fonte-fora-do-sistema (critério adr-178 dec 4, não alegação) e que migrationRef aponta def existente no disco cujo tema é a migração dessa origem (classe def-081); gapPolicy proíbe fabricar a justificativa. Hardening de processo sobre tq-fcc-02 do schema (já fail)."
			severity:    "fail"
			rationale:   "O não-padrão net-new é precedente poderoso (adr-178 N3): invocado sem demonstração vira digitação-por-preguiça vestida de origem — exatamente o sinal (a) da falsificationCondition do adr-178 que o review deve vigiar."
		}, {
			id:          "tq-fcg-03"
			description: "Guide força classificação fiel à capacidade: movesMoney contra o domínio e kind contra o recorte real"
			test:        "Process das sections family-classification e action-slots exige derivar kind do recorte verificado (command mutável exposto → action-bearing; leitura genuína → read-only) e movesMoney do domínio do command (autoriza/move/reserva valor financeiro ⇒ true), com calibração do founder nos casos ambíguos; gapPolicy proíbe classificar por conveniência (omitir command do recorte para obter read-only; movesMoney false para escapar de Approval-as-Confirmation). Hardening sobre tq-fcc-03 (fail) + cobertura do sinal secundário da falsificationCondition do adr-179 (não-aplicabilidade declarada em família que expõe command)."
			severity:    "fail"
			rationale:   "As exclusões por shape só protegem se a classificação que as alimenta for verdadeira — P10 em pixel (Approval-as-Confirmation) depende deste julgamento, e o shape não o verifica; a mentira de classificação é o único caminho que resta para burlar o mandato."
		}, {
			id:          "tq-fcg-04"
			description: "Guide contém o grandfathering ao legado pré-adr-180"
			test:        "Process da section read-surfaces exige confirmar, para cada readSurface com viewRegime hand-grandfathered, a view hand correspondente existente ANTES do adr-180 (fila escalada da 1ª família, canvas-backed; fila de triagem da 2ª, query-backed) e declarar generated para toda view nova; gapPolicy proíbe criar entry hand-grandfathered nova. Paralelo de processo sobre tq-fcc-04 do schema (warn)."
			severity:    "warn"
			rationale:   "O grandfathering ilumina dívida, não a cria (adr-180 dec 3) — a lista hand só encolhe por migração a generated; regime hand em superfície nova reabriria o buraco que a promoção fechou."
		}]
		rationale: "4 critérios guardam o lado de PROCESSO de autoria que o shape do schema alvo não alcança, espelhando 1:1 os tq-fcc-01..04 da instância: anti-fabricação de refs e slots (tq-fcg-01), demonstração do net-new (tq-fcg-02), fidelidade de classificação kind+movesMoney (tq-fcg-03), contenção do grandfathering (tq-fcg-04). Severities espelham o schema (01-03 fail, 04 warn) — hardening de severity é desnecessário porque os critérios de instância já nascem calibrados pelo mandato adr-179; o guide adiciona o COMO verificar (leitura direta do domain-model, teste de substituição, calibração founder, correspondência 1:1 com o legado) que os critérios de instância pressupõem."
	}

	prerequisites: {
		description: "Antes de criar ou editar o frontend-codegen-contract (singleton; autoria típica é edição — nova família, nova action, nova read surface), agente lê o schema #FrontendCodegenContract + a instância vigente em governance/build-time/frontend-codegen-contract.cue + a cadeia normativa (adr-150 lei de UX; adr-178 critério net-new e 2ª família; adr-179 mandato dos 3 slots; adr-180 promoção) + o domain-model do BC da família tocada, e confirma com o founder o recorte da superfície antes de qualquer declaração."
		collectFromFounder: [
			"ADR autorizador da mudança (id adr-NNN existente, entra em authorizedBy) + recorte da superfície decidido: quais commands, events, VOs, estados de lifecycle e queries entram na família — o recorte é decisão registrada em ADR, não inferência do agente",
			"Classificação da família por capacidade quando o recorte deixar ambiguidade: action-bearing (expõe command/ação mutável) vs read-only (leitura genuína) — a distinção deriva do recorte tipado (falsificationCondition adr-179); o founder decide o caso-limite",
			"Calibração de movesMoney por action quando a natureza financeira do command não for inequívoca no domain-model (autoriza/move/reserva valor ⇒ true) — agente NÃO infere para escapar do gate nem para decorá-lo; Approval-as-Confirmation entra por constraint quando true",
			"Para origem net-new: a demonstração de fonte-fora-do-sistema (fato de produto que só o founder atesta — molde adr-178: o cronograma físico do canteiro) + o def de migração da origem, existente no disco ou criado ANTES na mesma fatia (cascade do PG de deferred-decision)",
			"Version bump da instância + defs novos em activeBoundaries quando a mudança pressupõe deferral novo — e confirmação de que status NÃO flipa na autoria (flip proposed→accepted é decisão do founder por evidência spec-side, harness def-065)",
		]
		gapPolicy:     "NÃO invente ids de domínio — todo commandRef, returnsEvents, aggregateRef, valueObject, event, lifecycleState e queryRef é verificado por leitura direta do domain-model do sourceModel ANTES de declarado; id ausente → STOP (a fatia de domínio precede a superfície; o contrato não inventa domínio). NÃO fabrique netNewJustification — se a demonstração de fonte-fora-do-sistema não puder ser feita, a origem é system (Generative Form padrão da adr-150) ou a família espera. NÃO aponte migrationRef para def inexistente — o def de migração nasce antes, nunca dangling. NÃO classifique por conveniência: omitir command do recorte para obter read-only, ou movesMoney false para escapar de Approval-as-Confirmation, são o mesmo vetor do action-surface fictício. NÃO crie readSurface hand-grandfathered nova — o regime é exclusivo do legado pré-adr-180. NÃO preencha slot com texto genérico reutilizável — slot que sobrevive à troca do command é placeholder. NÃO decida linguagem-alvo, forma/sintaxe ou mecanismo de gate — são runtime-local (fronteira QUE=spec/COMO=runtime do adr-158; a decomposição do antigo def-060 vive no adr-159, com os deferrals vivos def-066/def-067/def-068). NÃO flipe status proposed→accepted. Quando dúvida persistir, pergunta direta ao founder; nunca preencha por inferência heurística."
		validatorNote: "cue vet valida o coração do mandato POR SHAPE: read-only com actions não compila; action-bearing sem actions não compila; movesMoney true sem approvalAsConfirmation não compila; net-new sem netNewJustification+migrationRef não compila; canvas-backed fora de hand-grandfathered não compila. O que resta ao review (self-review + founder): substância dos slots (tq-fcc-01), demonstração do net-new (tq-fcc-02), fidelidade de movesMoney e kind (tq-fcc-03), contenção do grandfathering (tq-fcc-04) — dimensões de julgamento contra domínio e legado, não automatizáveis por shape. O structural-check do tipo (sc-fcc — nasce na MESMA fatia, adr-180 dec 5) cobre os casos adversariais e as refs cross-file pós-commit como 2ª camada determinística."
		outputNote:    "Output é o arquivo singleton governance/build-time/frontend-codegen-contract.cue conformante a #FrontendCodegenContract (lar histórico preservado na promoção — zero movimentação, P0/adr-180). Autoria é edição in-place: nova família = nova entry em families; nova action = entry em actions[] da família; nova leitura = entry em readSurfaces. Tamanho cresce por família (~200-300 linhas na v2); version bump acompanha cada extensão."
	}

	workOrder: [
		"family-classification",
		"action-slots",
		"read-surfaces",
		"envelope-gate-and-output",
	]

	sections: {
		"family-classification": {
			target:    "#SurfaceFamily"
			objective: "Classificar a família tocada por CAPACIDADE do recorte — action-bearing (expõe command/ação mutável) vs read-only (leitura genuína) — e declarar a base da família (boundedContextRef, sourceModel, rationale; para action-bearing também aggregateRef, lifecycleStates, valueObjects, events) com todo ref verificado por leitura no domain-model."
			process: [{
				action: "Ler o ADR autorizador da mudança e o domain-model do BC (sourceModel)"
				detail: "O recorte da superfície vem do ADR/founder (prerequisites); o domain-model é a fonte dos ids. Sem essas duas leituras qualquer declaração é fabricação — este passo precede todos os demais."
			}, {
				action: "Verificar cada id do recorte por leitura direta no domain-model"
				detail: "agg-*, cmd-*, evt-*, vo-* e estados de lifecycle declarados devem existir no domain-model do sourceModel (Read/grep no arquivo). Id ausente → STOP e escalar: a fatia de domínio precede a superfície; o contrato não inventa domínio."
			}, {
				action: "Avaliar a capacidade do recorte para derivar kind"
				detail: "Recorte expõe command/ação mutável → action-bearing (actions ≥1 por shape). Recorte genuinamente só de leitura → read-only (readSurfaces ≥1; o campo actions não existe por shape). A distinção deriva do recorte tipado, não de julgamento subjetivo (falsificationCondition adr-179); caso-limite → founder decide."
			}, {
				action: "Declarar sourceModel, boundedContextRef e rationale da família"
				detail: "sourceModel é path real do domain-model (ex.: contexts/p2p/domain-model.cue); boundedContextRef é o code do BC (canvas). rationale ancora a família no ADR autorizador e na jornada — por que ESTA superfície existe agora."
			}, {
				action: "Declarar aggregateRef, lifecycleStates, valueObjects e events (famílias action-bearing)"
				detail: "lifecycleStates é a disjunção que a superfície precisa, com fidelidade ao domínio: subset legítimo (1ª família: só escalated) ou enum completo (2ª família: os 6 estados da requisição) — estado inventado quebra P14. valueObjects e events listam o recorte verificado, nunca o catálogo inteiro do BC."
			}]
			sources: [
				"architecture/artifact-schemas/frontend-codegen-contract.cue (#SurfaceFamily, união discriminada por capacidade — nasce na mesma fatia)",
				"governance/build-time/frontend-codegen-contract.cue (instância vigente — famílias 1-2 como referência calibradora)",
				"architecture/adrs/adr-179-frontend-promotion-mandate-reading-contract.cue (mandato + falsificationCondition da capacidade tipada)",
				"architecture/adrs/adr-178-journey-start-surface-kit-and-net-new-origin.cue (recorte da 2ª família como precedente de recorte)",
				"contexts/{bc}/domain-model.cue (fonte de verdade dos ids da família tocada)",
			]
			heuristics: [
				"kind deriva do RECORTE REAL: omitir command do recorte para classificar read-only é o mesmo vetor do action-surface fictício — ambos são o sinal secundário da falsificationCondition do adr-179.",
				"read-only NÃO é família incompleta: é capacidade genuína — o mapa de cotações (a 3ª família, o gatilho da promoção) é o precedente fundador; a fila do p2p NÃO é exemplo: vive como readSurface DENTRO da família action-bearing do p2p. Action de placeholder para cumprir o mandato é tão errado quanto omissão.",
				"Derived→source por construção: cada ref da família aponta o domain-model do sourceModel (1:1); a verificação por leitura é o complemento de processo — existência cross-file não é CUE-verificável (precedente aggregate-manifest).",
				"Zero nomes concretos de família no schema: a família nova entra como entry de families com ID descritivo; a validação vem da capacidade tipada, nunca de casos nomeados no schema (falsificationCondition adr-179).",
			]
			doneCriteria: "kind declarado e derivado do recorte verificado por leitura no domain-model; base da família completa (boundedContextRef, sourceModel, rationale ancorado no ADR autorizador); para action-bearing, aggregateRef + lifecycleStates fiéis ao domínio + valueObjects + events do recorte; nenhum id declarado sem verificação."
			ifGap:        "Se o recorte é ambíguo (command existe no domínio mas não se sabe se entra na superfície), pergunta direta ao founder — o agente não decide recorte. Se um id não existe no domain-model, STOP: a família espera o domínio; nunca declarar id especulativo."
		}

		"action-slots": {
			target:    "#Action"
			objective: "Autorar cada action da família action-bearing com os 3 slots do mandato adr-179 SUBSTANTIVOS e específicos ao command: actionPairing (Action-as-Tool), confirmation (returnsEvents + movesMoney calibrado; Approval-as-Confirmation por constraint quando dinheiro move) e generativeForm (origin system por default; net-new demonstrado com migração ancorada). Section aplica somente a famílias action-bearing — em read-only a não-aplicabilidade é por shape, sem placeholder."
			process: [{
				action: "Declarar commandRef verificado na section anterior"
				detail: "O id do command vem do recorte verificado por leitura (family-classification). Uma action por command exposto — command no recorte sem action, ou action sem command real, são ambos impossíveis de submeter."
			}, {
				action: "Compor actionPairing específico ao command"
				detail: "description descreve o par botão-humano+tool-de-agente derivado de UMA definição (adr-150 dec 2a) PARA ESTE command: a decisão que o botão executa e o que o tool expõe ao agente. rationale registra por que a ação existe na superfície. Texto reutilizável em outro command é placeholder."
			}, {
				action: "Declarar returnsEvents como os eventos-confirmação do domínio"
				detail: "Os eventos que a confirmação estruturada pode devolver (molde CMT/FCE: o POST devolve o evento emitido; lista ≥1 — oneOf quando o command tem desfechos alternativos, como o resolve da 1ª família com 2), verificados no domain-model — nunca evento inventado nem genérico."
			}, {
				action: "Avaliar movesMoney contra o domínio do command"
				detail: "Autoriza/move/reserva valor financeiro ⇒ true (referência vigente: o override do guard da 1ª família); submissão e triagem do p2p não movem (a reserva de cobertura pertence a cmd-approve-purchase, fatia futura). Ambiguidade → calibração do founder, nunca inferência. true ⇒ approvalAsConfirmation true por constraint — P10 em pixel: ação financeira TERMINA em confirmação estruturada, nunca em turno de chat livre."
			}, {
				action: "Declarar generativeForm.origin com o default da lei"
				detail: "origin system = Generative Form padrão da adr-150 (form pré-preenchido pelo agente; humano confirma/edita). net-new é o NÃO-PADRÃO instituído pelo adr-178 dec 4: apenas quando a informação não existe no sistema até o ato da observação humana."
			}, {
				action: "Documentar a demonstração e a migração quando origin é net-new"
				detail: "netNewJustification DEMONSTRA fonte-fora-do-sistema (input do founder — fato de produto; molde: o cronograma físico na visita técnica), não alega; migrationRef aponta def existente cujo tema é a migração dessa origem (classe def-081 — quando a fonte virar input de sistema, o preenchedor-agente entra sem mudança de shape)."
			}, {
				action: "Compor prefillNote específico ao form desta action"
				detail: "De onde o prefill de cada campo vem (item da fila selecionado, estado do aggregate, recomendação do agente-analista) — ou, em net-new, o shape pré-preenchível que nasce com conteúdo humano legítimo até a migração do def."
			}, {
				action: "Verificar substância dos 3 slots por teste de substituição"
				detail: "Trocar o command desta action por outro qualquer: se description, rationale ou prefillNote continuam válidos, são placeholder — reescrever específico (tq-fcc-01 fail)."
			}]
			sources: [
				"architecture/adrs/adr-150-frontend-ai-first-invariants.cue (a lei: os 3 patterns, dec 2a/2b/2c)",
				"architecture/adrs/adr-178-journey-start-surface-kit-and-net-new-origin.cue (dec 4: critério net-new; dec 5: migração def-081)",
				"architecture/adrs/adr-179-frontend-promotion-mandate-reading-contract.cue (dec 1: os 3 slots do mandato)",
				"governance/build-time/frontend-codegen-contract.cue (action-surfaces vigentes das famílias 1-2 como calibradores: override financeiro; submissão net-new; triagem system)",
				"architecture/deferred-decisions/def-081-requisition-origin-prefill-when-schedule-becomes-system-input.cue (molde da classe de def de migração de origem)",
			]
			heuristics: [
				"Default+override da origem: system é a REGRA; net-new é EXCEÇÃO com demonstração — informação que JÁ existe no sistema e não é pré-preenchida é digitação-por-preguiça, proibida pelo padrão da lei (adr-178 dec 4, distinção dura).",
				"Approval-as-Confirmation é o human gate do par decide-execute (P10): o agente recomenda (prefill), o humano confirma em ação estruturada — a separação decisão/execução mora no slot de confirmation; nunca removê-la de fluxo financeiro para reduzir fricção.",
				"confirmation.rationale registra POR QUE a classificação (por que move ou não move dinheiro NESTE command) — é o registro que tq-fcc-03 audita contra o domínio.",
				"Campo aberto no domínio permanece aberto na superfície (P14): o espelho não inventa enum que o domínio não fecha (precedentes: decision do override; outcome da triagem) — transparência no slot; selar é backlog do domain-model, não do contrato.",
			]
			doneCriteria: "Cada action da família com commandRef + returnsEvents verificados; movesMoney calibrado contra o domínio (founder nos ambíguos) com rationale de classificação; origin system por default; net-new somente com demonstração de fonte-fora-do-sistema + migrationRef para def existente; os 3 slots aprovados no teste de substituição."
			ifGap:        "Se o founder não demonstrar fonte-fora-do-sistema, a origem NÃO é net-new — declarar system ou reavaliar a fatia com o founder. Se o def de migração não existe, criá-lo ANTES (cascade: PG de deferred-decision) — nunca migrationRef dangling. Se a natureza financeira permanecer ambígua após leitura do domain-model, pergunta direta — nunca classificar por conveniência."
		}

		"read-surfaces": {
			target:    "#ReadSurface"
			objective: "Ancorar cada superfície de leitura da família: query-backed com qry-* formal do domain-model (obrigatória para TODA view no regime generated) vs canvas-backed (exclusiva do legado hand-grandfathered) — com generated como default pós-promoção e o grandfathering contido ao legado pré-adr-180."
			process: [{
				action: "Identificar as leituras da família a partir do recorte"
				detail: "Queries de fila/mapa/painel decididas no ADR autorizador (prerequisites). Leitura fora do recorte não entra — a família declara o que a superfície consome, não o catálogo do BC."
			}, {
				action: "Verificar a query capability no domain-model do sourceModel"
				detail: "qry-* declarado no domain-model (Read direto; regex qry-*). Capability existente → ramo #QueryBackedReadSurface com queryRef; view e rationale próprios da leitura."
			}, {
				action: "Declarar viewRegime generated para toda view nova"
				detail: "Pós-adr-180, view nova nasce generated — e o shape exige queryRef formal nesse regime: view gerada sem query capability é impossível por construção. hand-grandfathered em view nova viola adr-180 dec 3."
			}, {
				action: "Documentar o legado hand-grandfathered com correspondência 1:1"
				detail: "Cada entry hand-grandfathered corresponde a view hand existente ANTES do adr-180 e nomeável: a fila escalada da 1ª família (canvas-backed — sem qry formal; canvasSurfaceRef aponta a query-surface do canvas do BC) e a fila de triagem da 2ª (query-backed — qry formal com view hand). O shape força o regime no ramo canvas-backed."
			}, {
				action: "Verificar a contenção do grandfathering"
				detail: "Nenhuma entry NOVA com regime hand (tq-fcc-04 warn): família ou view nova no regime hand é retrocesso — a lista hand só encolhe, por migração a generated."
			}]
			sources: [
				"architecture/artifact-schemas/frontend-codegen-contract.cue (#ReadSurface: união query-backed | canvas-backed — nasce na mesma fatia)",
				"governance/build-time/frontend-codegen-contract.cue (regimes vigentes: fila escalada da 1ª família; fila de triagem da 2ª)",
				"contexts/{bc}/domain-model.cue (query capabilities qry-* da família tocada)",
				"contexts/{bc}/canvas.cue (query-surfaces — somente para o ramo canvas-backed do legado)",
			]
			heuristics: [
				"Se a leitura desejada não tem qry-* formal: o caminho é a query capability nascer no domain-model PRIMEIRO (fatia de domínio) — nunca canvas-backed novo (shape proíbe fora do legado) nem view hand nova (adr-180 dec 3).",
				"Default+override do regime: generated é a regra; hand-grandfathered é exceção fechada no tempo (pré-adr-180) — não é válvula para view futura.",
				"O grandfathering ilumina dívida, não a cria: entry hand nova é retrocesso; a direção única é a migração do legado para generated.",
			]
			doneCriteria: "Cada readSurface com queryRef verificado no domain-model (ou canvasSurfaceRef do legado); regime generated em toda view nova; entries hand-grandfathered mapeadas 1:1 a views hand pré-adr-180 nomeáveis; rationale de cada leitura ancorado na família."
			ifGap:        "Se a query capability não existe no domain-model, STOP e escalar — a fatia de domínio precede a superfície; NÃO inventar qry-* nem contornar via canvas-backed novo. Se não for possível nomear a view hand pré-adr-180 correspondente a uma entry hand-grandfathered, a entry não é legado — reclassificar como generated ou remover."
		}

		"envelope-gate-and-output": {
			target:    "#FrontendCodegenContract"
			objective: "Compor ou atualizar o envelope do contrato (version, status, authorizedBy, uxSemantics), o contractGate, output e activeBoundaries, e o rationale do contrato — coerentes com as famílias declaradas e com a fronteira QUE=spec / COMO=runtime."
			process: [{
				action: "Declarar version bump da extensão sem tocar status"
				detail: "Toda adição de família/action/readSurface bumpa version. status permanece proposed até flip por evidência spec-side + decisão do founder (harness def-065; precedente codegen-validation-evidence, adr-148 item 8) — o agente NUNCA flipa na autoria."
			}, {
				action: "Listar authorizedBy com ADRs verificados no disco"
				detail: "Acrescentar o ADR autorizador da mudança; verificar a existência do arquivo de cada adr-NNN em architecture/adrs/ — cadeia de autorização sem elo fantasma."
			}, {
				action: "Verificar uxSemantics como ponteiro para a lei"
				detail: "source aponta adr-150; provides nomeia os patterns — APONTA, nunca copia nem parafraseia (P0): atribuir à lei texto que ela não tem é a classe de erro que o adr-178 corrigiu (o ADR institui, não cita)."
			}, {
				action: "Verificar contractGate: capacidade, enforcement owner e mecanismo delegado"
				detail: "validates (capabilities vinculantes), binding, breakOnSchemaChange, runsIn (frontend-runtime CI) e scope declarados; mechanism é runtime-local (fronteira adr-158; pós-decomposição adr-159 não há def único para o mecanismo do gate — o COMO pertence ao frontend-runtime). O gate declara a CAPACIDADE e ONDE ela roda, não o COMO. Extensão de família raramente muda o gate; capability nova de validação é mudança semântica → proposta explícita ao founder."
			}, {
				action: "Declarar output refletindo cada família"
				detail: "artifacts nomeia os artefatos gerados da família nova; committedHere false por shape (P1 estrito — output vive no frontend-runtime, nunca aqui); goldenExample registra o estado de materialização por família (materializado vs pendente)."
			}, {
				action: "Avaliar activeBoundaries contra os defs vivos"
				detail: "Defs que o contrato pressupõe (def-060/def-064/def-065 na v2); adicionar def novo se a extensão pressupõe deferral novo; def sai quando deixa de estar VIVO — resolved OU withdrawn (o caso real da migração v3: def-060 withdrawn per adr-159 sai da lista) — lista viva, verificada por STATUS contra architecture/deferred-decisions/."
			}, {
				action: "Compor o rationale do contrato como síntese da extensão"
				detail: "Registra a cadeia de autorização, a fronteira QUE=spec/COMO=runtime (linguagem-alvo/forma runtime-local — fronteira adr-158; pós-decomposição adr-159 sem def único pendente) e o que a extensão corrente adicionou — síntese, não repetição das famílias."
			}]
			sources: [
				"governance/build-time/frontend-codegen-contract.cue (instância vigente: envelope, gate e boundaries da v2)",
				"architecture/adrs/adr-158-frontend-codegen-contract.cue (autoriza a relação de codegen; gate reforçado frontend-scoped)",
				"architecture/adrs/adr-148-mesh-runtime-bootstrap-handoff.cue (item 8: regime de flip por evidência + decisão do founder)",
				"architecture/adrs/adr-159-decompose-grouped-deferred-decision.cue (a decomposição do def-060: onde cada delegação runtime-local vive hoje — def-066/def-067/def-068; o mecanismo do gate ficou runtime-local sem def pendente)",
				"architecture/deferred-decisions/def-065-frontend-codegen-validation-harness.cue (harness da evidência que carrega o flip)",
			]
			heuristics: [
				"Enforcement owner declarado por construção (contractGate.runsIn + mechanism): o contrato declara ONDE cada capability é enforçada (frontend-runtime CI) e delega o COMO ao frontend-runtime (fronteira adr-158/adr-159) — não duplicar enforcement na spec.",
				"committedHere false é lei de shape: registrar output gerado no mesh-spec não valida — P1 estrito é a fronteira do contrato.",
				"status flip é decisão do founder por evidência (precedente codegen-validation-evidence + adr-148 item 8) — autoria propõe, nunca promove.",
			]
			doneCriteria: "version bumped e status inalterado pelo agente; authorizedBy completo com ADRs verificados no disco; uxSemantics apontando a lei; contractGate coerente (capabilities + enforcement owner + mechanism runtime-local); output refletindo todas as famílias com committedHere false; activeBoundaries viva; rationale síntese da extensão."
			ifGap:        "Se a extensão exige decisão que o contrato não contém (capability nova de gate, view-de-query entrando no codegen, mudança de fronteira spec/runtime), STOP — é decisão de ADR, não de edição in-place (sinal (c) da falsificationCondition do adr-178: a revisita antecipa, não improvisa)."
		}
	}

	finalValidation: {
		reconciliation: {
			description: "Invariantes cross-field do contrato composto, conferidos sobre a instância antes da submissão."
			pairs: [
				"Cada entry de families ↔ ADR autorizador correspondente presente em authorizedBy — cadeia de autorização por família, sem elo ausente.",
				"output.artifacts e output.goldenExample ↔ families — cada família declarada aparece nos artefatos e no estado de materialização.",
				"Cada readSurface hand-grandfathered ↔ view hand pré-adr-180 nomeável (fila escalada da 1ª família canvas-backed; fila de triagem da 2ª query-backed) — correspondência 1:1, sem entry nova.",
				"Cada generativeForm.migrationRef e cada def de activeBoundaries ↔ def VIVO (status open ou triggered) em architecture/deferred-decisions/ — existência de arquivo NÃO basta (withdrawn/resolved preservam arquivo para ponteiros históricos).",
			]
		}
		steps: [
			"Verificar shape: instância valida contra #FrontendCodegenContract via cue vet — incluindo as exclusões por shape do mandato (read-only com actions rejeitado; action-bearing sem actions rejeitado; movesMoney true sem approvalAsConfirmation rejeitado; net-new sem netNewJustification+migrationRef rejeitado; canvas-backed fora de hand-grandfathered rejeitado).",
			"Verificar tq-pg-01 / tq-mg-01: workOrder é permutação exata das chaves de sections (4 sections; sem redundância, omissão ou duplicata).",
			"Verificar tq-pg-02: cada section.target referencia tipo existente no schema alvo (#SurfaceFamily, #Action, #ReadSurface, #FrontendCodegenContract).",
			"Verificar tq-pg-04 / tq-mg-04: prerequisites.gapPolicy ≥50 runes E declara comportamento anti-invenção (cláusulas NÃO invente ids, NÃO fabrique netNewJustification, NÃO classifique por conveniência, NÃO crie hand-grandfathered novo, NÃO decida o runtime-local, NÃO flipe status).",
			"Verificar tq-pg-05 / tq-mg-03: finalValidation.steps[-1] é submissão ao founder como step próprio bloqueante distinto.",
			"Verificar tq-pg-06 / tq-mg-02: cada section.process[].action começa com verbo imperativo concreto da lista canônica (Ler, Verificar, Avaliar, Declarar, Compor, Documentar, Identificar, Listar).",
			"Verificar tq-fcc-01 / tq-fcg-01 (fail): cada action com os 3 slots SUBSTANTIVOS específicos ao command (teste de substituição aplicado) e todo ref (commandRef, returnsEvents, queryRef, aggregateRef, valueObjects, events, lifecycleStates) verificado por leitura no domain-model do sourceModel.",
			"Verificar tq-fcc-02 / tq-fcg-02 (fail): toda origem net-new com netNewJustification que DEMONSTRA fonte-fora-do-sistema (critério adr-178 dec 4, não alegação) e migrationRef apontando def existente cujo tema é a migração dessa origem.",
			"Verificar tq-fcc-03 / tq-fcg-03 (fail): movesMoney fiel ao domínio de cada command (verificado contra o domain-model; founder calibrou os ambíguos) e kind fiel à capacidade real do recorte — nenhuma família read-only escondendo command mutável do recorte.",
			"Verificar tq-fcc-04 / tq-fcg-04 (warn): toda readSurface hand-grandfathered corresponde a view hand pré-adr-180; nenhuma família/view NOVA no regime hand; canvas-backed apenas no legado.",
			"Verificar reconciliation: os 4 pairs cross-field conferidos sobre a instância composta (families↔authorizedBy; output↔families; hand-grandfathered↔legado; migrationRef/activeBoundaries↔defs no disco).",
			"Verificar canonical removal (tq-mg-10 warn): removido o frontend-codegen-contract, os invariants críticos permanecem protegidos por outros enforcers? Resposta esperada SIM — o piso e os invariants do domínio são garantidos primariamente pelo domain-model + handlers (defesa-em-profundidade declarada no próprio contractGate); a lei dos patterns permanece no adr-150; o enforcement de build vive no frontend-runtime CI. O contrato é OPERADOR declarativo (mapa da geração + mecanização spec-side do mandato adr-179), não o único enforcer — resposta NÃO indicaria lógica de domínio vazando para o contrato.",
			"Submeter ao founder para aprovação explícita antes de commit — step próprio bloqueante per adr-057 founderConfirmation (gate humano distinto, NÃO absorvido na inspeção de critérios precedentes nem em self-review).",
		]
	}
}
