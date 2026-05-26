package self_reviews

import "github.com/sw6n297mn8-maker/mesh-spec/governance/build-time:build_time"

adr098EngineConfigZonesOrphanReject: build_time.#SelfReviewReport & {
	reportId: "srr-adr-098-engine-config-zones-orphan-reject"

	artifactPath:       "architecture/adrs/adr-098-engine-config-zones-orphan-reject.cue"
	artifactSchemaPath: "architecture/artifact-schemas/adr.cue"
	artifactType:       "adr"

	canonicalSource: "governance/build-time/quality-gate.cue"
	executionMode:   "self-reported"
	generatedAt:     "2026-05-26"

	roundsExecuted: 1
	maxRounds:      3

	status: "stable"

	roundDetails: [{
		round:     1
		failCount: 0
		warnCount: 0
		infoCount: 0
		summary: """
			Self-review do adr-098 (zonas engine/config + promocao de orfao->reject,
			resolvendo def-018), cujo design e os 2 ajustes finais foram aprovados
			pelo founder antes da escrita. Confirmacoes:

			(a) Conformancia #ADR: id ^adr-[0-9]{3}$; status "accepted"
			(nao-superseded, supersededBy ausente); decisionClass "structural"
			coerente (adiciona campo a #Scope, formaliza a regra type-definition
			file, muda contrato de classificacao/exit do runner+gerador);
			reversibility "medium" + blastRadius "repo-wide" consistentes.
			tq-adr-01 (2 alternativas rejeitadas com motivo: schematizar os 10
			singletons = burocracia artificial; hardcode das zonas = duplicacao
			declaracao<->config que adr-090 elimina); affectedArtifacts = 5 paths
			reais e alterados; principlesApplied com rastreabilidade (P10/P0/
			adr-090/adr-097/dp-07).

			(b) Verificacao empirica antes da proposta (manualAuthoringProtocol):
			cue vet ./... EXIT 0; runner --self-test PASS; gerador --self-test PASS;
			apos as exclusoes (zonas + derivados/templates + type-definition files)
			o inventario de orfaos = 0 e ambiguos = 0; runner em modo default ->
			TOTAL 21 (sc-cv-02/03 em warn), 0 bloqueantes, exit 0. Logo a promocao
			orfao->reject NAO quebra o CI.

			(c) Coerencia da resolucao de def-018: condicao (1) schemas fundacionais
			satisfeita por adr-093/094 (triggers file-exists dispararam); condicao
			(2) zero orfaos satisfeita por estas exclusoes. def-018.status=resolved
			com resolvedBy = este ADR (#OriginRef path .cue). Cadeia de auditoria
			fechada.

			(d) Alinhamento runner<->gerador: predicado UNICO classification_skip
			compartilhado (importado pelo gerador via R), eliminando divergencia
			entre os dois mapas; GOVERNED_ELSEWHERE hardcoded removido em favor de
			exempt_zones() lido de repoStructure.scope.schemaExemptZones.
			"""
	}]

	findings: {}

	summary: """
		adr-098 conforma a #ADR e registra a decisao (aprovada pelo founder) de
		(i) formalizar governance/build-time/, governance/claude/ e
		architecture/conventions/ como engine/config zones declaradas em
		schemaExemptZones; (ii) a regra type-definition file (top-level #/_# =
		definicao, nao instancia); (iii) excluir derivados+deriver-templates; e
		(iv) promover orfao->reject, resolvendo def-018. Sem findings fail/warn.
		Verificacao empirica: orfaos=0, default exit 0 (CI nao quebra).
		"""

	singleRoundRationale: """
		Uma rodada basta: o design (zonas + 3 exclusoes + promocao) e os 2 ajustes
		finais (schemaExemptZones so com as 3 zonas; regra type-definition formal no
		ADR) foram propostos e aprovados pelo founder explicitamente antes da
		escrita, e a verificacao empirica (cue vet, ambos self-tests, inventario
		orfaos=0, default exit 0) e deterministica e passou. Sem espaco de decisao
		aberto a red-team adicional.
		"""
}
