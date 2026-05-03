package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

// adr-059 — Add plannedOutputs optional field to #ADR for new-created paths.
//
// Promove disciplina 3-way conceitual (existing-altered / new-created /
// derived-regenerated) documentada em PG-ADR (commit 3d6b7e3 + amendments)
// para schema first-class via novo field optional plannedOutputs. Schema
// pré-adr-059 conflate existing-altered + new-created em affectedArtifacts;
// derivedArtifacts cobre derived-regenerated. Este ADR adiciona
// plannedOutputs para new-created sem migration retroativa de ADRs
// existentes (field optional + grandfather strategy).
//
// Part 1 do plano de 3 partes para C3 (founder-approved partitioning):
// Part 1 (este) = setup; Parts 2/3 = migration recente / antiga deferred.
//
// Primeiro ADR a usar plannedOutputs no próprio cap table — auto-
// referencial: paths self-review reports são new-created por esta decisão.

adr059: artifact_schemas.#ADR & {
	id:    "adr-059"
	title: "Add plannedOutputs optional field to #ADR for new-created paths"
	date:  "2026-05-01"

	decisionClass: "structural"
	decider:       "founder"
	status:        "proposed"

	context: """
		State-of-affairs precedente:
		- Schema #ADR (architecture/artifact-schemas/adr.cue) declara
		  dois fields para traceability: affectedArtifacts (required,
		  comment 'Artefatos normativos criados ou alterados por esta
		  decisão') e derivedArtifacts (optional, 'Artefatos regenerados
		  ou ajustados como consequência'). Schema pré-adr-059 conflate
		  'criados' + 'alterados' em affectedArtifacts.
		- PG-ADR (architecture/production-guides/adr.cue, commit 3d6b7e3
		  + amendments) documenta disciplina 3-way conceitual: existing-
		  altered, new-created, derived-regenerated. Discipline forward-
		  looking: 'enquanto schema não separar new-created como campo
		  próprio, arquivos novos criados pela decisão entram em
		  affectedArtifacts com rationale claro distinguindo-os dos
		  existing-altered.'
		- tq-adrg-03 (PG-ADR _qualityCriteria) já articula a discipline
		  3-way conceitual como warn — schema não enforce, autor mantém
		  disciplina manualmente.
		- 58 ADRs existentes (adr-001..adr-058) committed sob convenção
		  pré-adr-059 (affectedArtifacts conflate existing-altered +
		  new-created); todas válidas vs schema corrente.

		Trigger: opção C do plano de schema extensions (founder-approved
		sessão 2026-05-01). PG-ADR documenta discipline há tempo; valor
		marginal de schema field é separação automática que runner futuro
		pode validar (auditoria, planning visualization, coverage gap
		detection). C2 (failureHandling, adr-058) provou que promotion
		de tech debt narrative para field first-class é pattern válido
		quando volume e maturidade justificam.

		Alternativas avaliadas:
		(a) Manter discipline 3-way apenas em PG-ADR narrative permanente
		— rejeitada: PG-ADR já documenta há tempo; benefit marginal de
		adicionar field é separação automática e validation futura por
		runner.
		(b) Schema field plannedOutputs OPTIONAL + grandfather ADRs antigas
		(este ADR) — recomendado: novas ADRs usam pattern per discipline;
		antigas continuam válidas sem migration; field disponível para
		uso forward-looking sem coordination overhead.
		(c) Schema field plannedOutputs REQUIRED + migrar 58 ADRs em
		commit único — rejeitada: alta probabilidade de misclassificação
		(cada path requer git archaeology); risco ~40-70% de iteração;
		coordination overhead alto vs benefit marginal de enforcement
		uniforme imediato.
		(d) Schema field optional + migration gradual change-on-touch
		— adotada como complement: novas ADRs autoradas usam
		plannedOutputs; ADRs antigas migram quando forem touched por
		outras razões. Reduz drift sem custo de migration big-bang.
		"""

	decision: """
		(1) ADICIONAR campo plannedOutputs como OPTIONAL ao schema
		#ADRBase em architecture/artifact-schemas/adr.cue:
		    plannedOutputs?: [...string & !=""]
		Posicionado entre affectedArtifacts (required) e derivedArtifacts
		(optional) — agrupamento semântico por traceability dimension.

		(2) ATUALIZAR comments do schema para refletir 3-way semantic:
		- affectedArtifacts: 'Artefatos normativos existentes alterados
		  por esta decisão' (era 'criados ou alterados') + nota de
		  grandfather para ADRs pré-adr-059
		- plannedOutputs: 'Artefatos novos criados pela decisão como
		  output direto' (novo) + nota de optional/grandfather
		- derivedArtifacts: comment atual permanece

		(3) UPDATE PG-ADR (architecture/production-guides/adr.cue):
		- collectFromFounder item 6: clarify 3-way agora é schema-
		  supported via plannedOutputs field
		- prerequisites.gapPolicy: substituir 'enquanto schema não
		  separar new-created' por discipline straight-forward (3 fields
		  declarativos)
		- tq-adrg-03 description/test/rationale: substituir 'discipline
		  3-way conceitual' por 'field declarativo plannedOutputs (per
		  adr-059)'
		- Section 2 process action 3: renomear para incluir plannedOutputs
		- Section 2 heuristics relevantes: clarify field declarativo
		- Section 3 finalValidation step sobre paths: atualizar para
		  referenciar plannedOutputs

		(4) GRANDFATHER ADRs existentes (adr-001..adr-058): nenhuma
		migration retroativa. Field optional permite ADRs sem
		plannedOutputs continuarem válidas. ADRs novas pós-adr-059
		SHOULD usar plannedOutputs per discipline; runner futuro pode
		validar coverage para ADRs com data >= 2026-05-01 (este ADR).

		(5) MIGRATION POLICY change-on-touch: ADRs antigas migram quando
		forem touched por outras razões (amendment, supersession update,
		comment fix). Não force migration big-bang.

		(6) PARTS 2/3 do C3 plan (founder-approved): Part 2 (migrar
		adr-041..adr-058 = 18 ADRs recentes) e Part 3 (migrar adr-001..
		adr-040 = 40 ADRs antigas) deferidas. Decisão de executar Parts
		2/3 separada por commit independente quando founder priorizar.

		(7) MATERIALIZAÇÃO: single commit contendo este ADR + schema
		delta + PG-ADR update + 2 self-review reports (adr-059 + adr.cue
		schema). Decisão estrutural única; sem migration coordenada
		nesta etapa. Este ADR é primeiro a usar plannedOutputs (auto-
		referencial: 2 self-review reports são new-created por esta
		decisão).
		"""

	consequences: """
		Positivas:

		(P1) plannedOutputs disponível como schema field para novas ADRs
		— discipline 3-way agora declarativa, não apenas narrative em
		PG-ADR.

		(P2) ADRs existentes (58) continuam válidas — zero migration
		risk para state atual; field optional preserva backward compat
		completo.

		(P3) Runner futuro pode validar coverage 3-way para ADRs com
		data >= 2026-05-01 (data deste ADR como threshold de adoção).

		(P4) Pattern reusable estabelecido para optional schema extensions
		com grandfather strategy — alternativa controlada a required +
		big-bang migration.

		(P5) PG-ADR alinha com schema reality — tq-adrg-03 evolui de
		'discipline 3-way conceitual' (warn manual) para 'field
		declarativo' (warn enforced via inspection do field).

		Negativas:

		(N1) Drift de coverage entre ADRs antigas (sem plannedOutputs)
		e novas (com plannedOutputs) — discipline aplicada inconsistente
		mente no histórico. Mitigação: migration policy change-on-touch;
		Parts 2/3 disponíveis se enforcement uniforme for priorizado
		posteriormente.

		(N2) Optional field não enforce coverage para novas ADRs — autor
		pode omitir plannedOutputs e colocar tudo em affectedArtifacts
		(regressão à convenção antiga). Mitigação: tq-adrg-03 valida via
		PG check; runner futuro pode warn para ADRs pós-adr-059 sem
		plannedOutputs declarado quando contextualmente esperado.

		(N3) Schema cresce com field opcional — ADR sem plannedOutputs
		é estruturalmente válido mas conceitualmente incompleto pós-
		adr-059. Mitigação: documentação clara em comment do field +
		PG-ADR discipline.

		(N4) Reversibilidade alta apenas porque field é optional;
		promover para required posteriormente exige Parts 2/3 migration
		completa. Mitigação: decisão de promover é separada (Part 4
		opcional); reversão deste ADR sem Parts 2/3 é trivial (remove
		field, nenhuma instance afetada exceto este ADR e ADRs futuras
		pós-adr-059).
		"""

	reversibility: "high"
	blastRadius:   "cross-artifact"

	affectedArtifacts: [
		"architecture/artifact-schemas/adr.cue",
		"architecture/production-guides/adr.cue",
	]

	plannedOutputs: [
		"governance/build-time/self-reviews/adr-059.self-review.cue",
		"governance/build-time/self-reviews/adr-schema-plannedoutputs.self-review.cue",
	]

	principlesApplied: [
		"P0",
		"P12",
	]

	rationale: """
		Princípios aplicados:

		P12 (governança como código) é o driver primário: discipline
		3-way em narrative do PG-ADR é discipline enforced apenas via
		review; schema field declarativo é discipline enforced via
		tooling (cue vet shape; runner futuro coverage). Move concern
		de PG narrative para schema first-class.

		P0 (localização canônica única): plannedOutputs vive em UM
		lugar (envelope.plannedOutputs field) per ADR. Discipline 3-way
		conceitual em PG-ADR continua relevante como guidance, mas
		paths classificados vivem em fields schema, não em prosa de
		rationale.

		Failure mode evitado: discipline 3-way perdida em ADRs autoradas
		sob pressão temporal — autor omite distinção em narrative quando
		schema não modela. Field optional + validation via tq-adrg-03
		reduz vulnerabilidade.

		Sem axiomas tensionados.

		Lenses consultadas:

		lens-real-options: optional field + grandfather strategy preserva
		opção de evoluir para required posteriormente (Parts 2/3 + Part
		4) sem committment imediato. Migration big-bang seria one-way
		door — optional + change-on-touch é reversible.

		Relação com outras ADRs:

		- PROMOTE discipline 3-way conceitual de PG-ADR (commit 3d6b7e3
		  + amendments) de narrative para schema first-class field.
		  Pattern paralelo a adr-058 (failureHandling).
		- GRANDFATHER ADRs existentes (adr-001..adr-058) sem migration
		  — field optional preserva backward compat.
		- PRECEDE Parts 2/3 (migration deferida): Part 2 = adr-041..
		  adr-058 recente; Part 3 = adr-001..adr-040 antigas.
		- SEM supersession.

		Justificativa de risk metadata:

		reversibility 'high': field optional pode ser removido sem afetar
		ADRs existentes (58 não usam o field). Reversão é trivial —
		remover field do schema + remover refs em PG-ADR + remover refs
		em este ADR (única instância usando o field). Coherence rule:
		optional field + zero usage atual = high reversibility.

		blastRadius 'cross-artifact': afeta schema #ADR + PG-ADR + future
		ADRs. Não atravessa múltiplos domínios (não é cross-cutting);
		afeta múltiplos artefatos no mesmo cluster (governance/
		architecture-decision). Não é cross-cutting (não muda
		comportamento de governance system wide; só adiciona opção
		declarativa) nem repo-wide.
		"""
}
