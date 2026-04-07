package validation_prompts

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

validationPrompts: "vp-domain-definition": artifact_schemas.#ValidationPrompt & {
	id:    "vp-domain-definition"
	title: "Validação semântica de Domain Definition"

	matchPatterns: ["^domain/domain-definition\\.cue$"]

	appliesTo: ["domain-definition"]

	reviewContract: "advisory-only"

	references: [
		"architecture/artifact-schemas/domain-definition.cue",
		"architecture/design-principles.cue",
	]

	checks: [{
		id:         "vc-dd-01"
		question:   "A coreThesis forma um argumento causal coerente: problema → mecanismo → resultado? Ou há saltos lógicos entre as partes?"
		lookFor:    "Desconexão entre o problema descrito (custos de transação por assimetria informacional) e os mecanismos propostos. Mecanismos que não contribuem para resolver o problema declarado. Resultados prometidos que não decorrem dos mecanismos. Teste: removendo qualquer mecanismo, a tese ainda se sustenta? Se sim, o mecanismo é decorativo."
		outputMode: "narrative"
		severity:   "fail"
		rationale:  "A coreThesis é a premissa de todo o sistema. Salto lógico na tese propaga-se como incoerência em todos os artefatos derivados. O agente que escreveu a tese sofre viés de coerência narrativa — perspectiva externa detecta gaps que o autor preenche inconscientemente."
	}, {
		id:         "vc-dd-02"
		question:   "As antiThesis cobrem os riscos existenciais mais óbvios, ou há riscos evidentes não listados?"
		lookFor:    "Riscos que um investidor ou regulador perguntaria na primeira reunião e que não aparecem em antiThesis. Riscos que invalidariam a tese inteira (não apenas um mecanismo). Anti-teses que são variações do mesmo risco reembalado. Ausência de riscos de execução (equipe, capital, timing de mercado) — se intencionalmente fora de escopo, verificar se está documentado."
		outputMode: "finding-only"
		severity:   "fail"
		rationale:  "Anti-teses são o mecanismo de honestidade intelectual do artefato. Gaps em anti-teses indicam blind spots do autor — exatamente o que validação por agente separado deve capturar."
	}, {
		id:         "vc-dd-03"
		question:   "O flywheel é genuinamente circular (cada step alimenta o próximo até fechar o ciclo) ou há steps que quebram a cadeia causal?"
		lookFor:    "Steps onde feedsInto é forçado — a conexão causal entre ação e próximo step não é evidente sem explicação adicional. Steps que dependem de premissas externas não declaradas (e.g., 'novos participantes aparecem' sem explicar o incentivo). Flywheel que só funciona em cenário otimista — verificar se funciona com volume baixo ou crescimento lento."
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "Flywheel quebrado é narrativa, não mecanismo. warn porque circularidade perfeita pode ser aspiracional na fase inicial — o importante é que as quebras estejam documentadas."
	}, {
		id:         "vc-dd-04"
		question:   "As entradas em notIdentity seriam claras para alguém de fora do projeto (investidor, parceiro, candidato)? As distinções são operacionais ou apenas semânticas?"
		lookFor:    "Distinções que dependem de vocabulário interno do projeto para serem compreendidas. whyConfused que não captura a confusão real do mercado — projeção do autor sobre o que outros pensam. distinction que usa negações ('não é X') sem afirmar o que é. Teste: um outsider lendo apenas notIdentity conseguiria explicar o que a Mesh é?"
		outputMode: "narrative"
		severity:   "warn"
		rationale:  "notIdentity existe para comunicação externa. Se as distinções só fazem sentido para quem já entende o projeto, o artefato falha em seu propósito. warn porque clareza para outsiders é iterativa."
	}]

	rationale: "Domain definition é o artefato fundacional — tudo deriva dele. Validação semântica por agente separado verifica coerência causal da tese, completude de anti-teses, circularidade do flywheel, e clareza de identidade para outsiders — aspectos onde viés do autor é máximo."
}
