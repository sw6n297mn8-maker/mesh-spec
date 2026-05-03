package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-adopted-artifacts": artifact_schemas.#ValidationPrompt & {
	id:    "vp-adopted-artifacts"
	title: "Validação semântica do manifest de artefatos adotados"

	matchPatterns: ["^governance/adopted-artifacts\\.cue$"]

	appliesTo: ["adopted-artifacts"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/adopted-artifacts.cue",
		"governance/adopted-artifacts.cue",
		"architecture/design-principles.cue",
	]

	checks: [{
		id:         "vc-aa-01"
		question:   "Para cada artifact, o adoptionMode declarado reflete a divergência real entre conteúdo local e source? E.g., verbatim mas local tem comments/imports diferentes (deveria ser extended); extended mas local é byte-idêntico ao source (deveria ser verbatim)."
		lookFor:    "adoptionMode=verbatim em artifact que tem package declaration local diferente, imports adaptados, ou comments adicionais — incompatível com fidelity verbatim. adoptionMode=extended sem identificar onde estão as extensões locais. adoptionMode=forked com mudanças triviais que caberiam em extended. Comparação local vs source é interpretativa e exige leitura dos dois lados."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "adoptionMode incorreto mascara drift silencioso entre source e local. Mode otimista (verbatim quando deveria ser extended) tipifica como 'cópia exata' algo que diverge — quebra a auditabilidade da adoção. tq-aa-05 é warn CI sobre hash matching; este check é semântico sobre adequação do mode ao tipo de divergência, não só sobre presence/absence de hash."
	}, {
		id:         "vc-aa-02"
		question:   "Para artifacts com adoptionMode != verbatim, overrideReason especifica POR QUE upstream é inadequado para o uso local, ou é genérico (\"precisava adaptar\", \"modificações necessárias\")?"
		lookFor:    "overrideReason curto que descreve O QUE foi mudado em vez de POR QUE. Ausência de menção ao constraint local que justifica divergência. Reasons que poderiam aplicar-se a qualquer artifact ('compatibilidade local'). Shape (MinRunes 10) garante presença mas não substantividade."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "overrideReason é o registro de por que esta adoção não pôde ser verbatim. Reason genérico esconde a decisão real e impede revisão futura. Quando upstream evoluir, agente futuro precisa saber se a divergência local ainda é necessária — reason que descreve apenas O QUE não permite essa avaliação."
	}, {
		id:         "vc-aa-03"
		question:   "Para artifacts com adoptionMode=migration-pending: migrationDeadline é compatível com complexidade do migrationPlan, e — crucialmente — se deadline já passou, há justificativa registrada no próprio artifact (e.g., overrideReason explica atraso, ou plan referencia bloqueador conhecido)?"
		lookFor:    "Deadline no passado sem nenhuma menção a por que ainda está migration-pending no artifact. Plan que enumera 1-2 passos triviais com deadline a 6+ meses (deadline frouxa). Plan que enumera transformação substantiva com deadline a 2 semanas (deadline irrealista). Padrão a evitar marcar como falso positivo: deadline passada COM justificativa explícita registrada no artifact = aceitável (atraso consciente)."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "Deadline migration-pending eternamente prorrogada é declaração de migração que nunca acontece (tq-aa-04 captura presença, não realismo). Warn (não fail) porque atraso pode ser consciente — check requer apenas que o atraso seja documentado no próprio artifact, não que seja eliminado. Evita falso positivo em atraso conscientemente registrado."
	}, {
		id:         "vc-aa-04"
		question:   "Para artifacts com adoptionMode=forked, compatibilityStatement especifica QUAIS contratos (campos, comportamentos, invariants) são preservados vs alterados, ou afirma compatibilidade em abstrato (\"compatível com upstream\")?"
		lookFor:    "compatibilityStatement que diz 'compatível' ou 'preserva contrato' sem nomear quais campos/funções/invariants. Ausência de menção ao que diverge (todo fork tem divergência por definição — ausência indica statement performativo). Shape (MinRunes 20) garante extensão, não conteúdo."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "Fork sem statement contratual concreto é risco de incompatibilidade silenciosa: consumers locais podem assumir comportamento upstream que o fork divergiu sem flag. Statement abstrato aparece como compliance sem prover informação acionável."
	}]

	rationale: "Manifest de adopted-artifacts é fonte de verdade para rastreabilidade cross-repo (FP-03, FP-07). Validação semântica verifica que o manifest não vira documento performativo: adoptionMode reflete a realidade de divergência, overrideReason justifica em vez de descrever, migration-pending tem realism check com escape para atraso documentado, e forked declara contratos concretos. Estas dimensões exigem comparação local↔source ou leitura interpretativa de campos textuais — fora do alcance de cue vet ou hash matching."
}
