package deferred_decisions

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

def057: artifact_schemas.#DeferredDecision & {
	id:     "def-057"
	title:  "Mecanismo de consolidacao de eventos consumidos cross-BC (espelhos em schemas de consumidor)"
	date:   "2026-06-12"
	status: "triggered" // trigger (1) file-exists contexts/rew/schemas/events.cue DISPAROU na Etapa 2 da fatia REW (PR #139, runner provado); resolucao na Etapa 3 (decisao founder)

	description: """
		A fatia FCE do WI-140 declarou em contexts/fce/schemas/events.cue o PRIMEIRO espelho cross-BC de um
		evento consumido: #InvoiceIssued, copia VERBATIM do canonico do INV (contexts/inv/schemas/events.cue),
		com pointer e proibicao de divergencia no comentario. Espelho e duplicacao controlada — viola P0/Zero
		Duplicacao na letra, mitigada por disciplina de comentario (nao por mecanismo). Fica deferida a decisao
		do MECANISMO definitivo de consolidacao: (a) eventos consumidos referenciam o package do produtor
		(import cross-BC no CUE + suporte do gerador a refs cross-contexto); (b) eventos publicados promovidos
		a architecture/shared-schemas/ por par produtor-consumidor real (precedente def-022/def-025); (c)
		espelho disciplinado vira regra com structural-check de identidade espelho<->canonico (diff mecanico
		em CI); ou (d) outra forma que a 2a instancia revelar.
		"""

	deferralRationale: """
		MOTIVO de deferir: ha exatamente UMA instancia de espelho (InvoiceIssued no FCE). Escolher mecanismo
		com n=1 e generalizar de exemplo unico — o erro que FP/P-principios de promocao por evidencia existem
		para impedir (precedente: def-022 Envelope e def-025 Money so consolidaram no 2o consumidor real).
		Custo evitado: mecanismo (import cross-BC no gerador, ou check de identidade) construido antes de saber
		a forma da recorrencia. Custo de continuar deferindo: espelhos adicionais nascem na mesma disciplina de
		comentario sem enforcement mecanico — drift espelho<->canonico e detectavel so por review ate o
		mecanismo existir; aceitavel enquanto a contagem e baixa e os espelhos carregam pointer + type string
		identica (o type e verificavel por grep).
		"""

	triggerCalibrationRationale: """
		Dois triggers: (1) file-exists em contexts/rew/schemas/events.cue — a materializacao de schemas do REW
		(ou BKR, coberto por manual-review) converte os FIXTURE-CONTRACTS do FCE em candidatos a espelho ou
		referencia, forcando a decisao do mecanismo no momento em que ha o 2o caso concreto; machine-evaluable
		por presenca de arquivo. (2) manual-review para o caso geral (2o espelho cross-BC declarado em QUALQUER
		consumidor, ou materializacao do BKR): a condicao 'novo espelho declarado' nao e machine-evaluable por
		path fixo — e padrao de conteudo que o founder reconhece em review de PR.
		"""

	originatingArtifacts: [
		"contexts/fce/schemas/events.cue",
		"contexts/inv/schemas/events.cue",
	]

	costOfDeferral: {
		severity:    "low"
		blastRadius: "cross-artifact"
		description: """
			low porque ha 1 espelho, com pointer + type string identica ao canonico (drift parcialmente
			detectavel por grep) e revisita declarada; nenhum fluxo bloqueado. cross-artifact porque o
			mecanismo escolhido incidira sobre schemas de multiplos BCs consumidores + o gerador
			(mesh-runtime) + possivelmente shared-schemas e structural-checks. Exit: decidir (a)-(d) na 2a
			instancia e materializar o mecanismo no mesmo pacote que a criar.
			"""
	}

	triggers: [{
		kind: "adjacent-need"
		condition: {
			kind: "file-exists"
			path: "contexts/rew/schemas/events.cue"
		}
	}, {
		kind:   "manual-review"
		reason: "O caso geral do trigger — '2o espelho cross-BC declarado em qualquer schemas de consumidor, ou materializacao de schemas do BKR' — nao e machine-evaluable por path fixo: e padrao de conteudo (novo #Evento de outro BC copiado em schemas alheio) que o founder reconhece em review; o trigger (1) cobre o caminho mais provavel (REW) mecanicamente."
	}]
}
