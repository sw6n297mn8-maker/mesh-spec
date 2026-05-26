package adr

import "github.com/sw6n297mn8-maker/mesh-spec/architecture/artifact-schemas:artifact_schemas"

adr104: artifact_schemas.#ADR & {
	id:    "adr-104"
	title: "Identidade canônica de event (name PascalCase, producer = SoT) + reconciliação built↔built"
	date:  "2026-05-26"

	decisionClass: "structural"
	decider:       "founder"
	status:        "accepted"

	context: """
		def-019 (diagnóstico afiado): o check events↔BC estava bloqueado não por
		falta de materialização — os events existem em domain-model.events[] — mas
		por VOCABULÁRIO inconsistente entre artefatos. O context-map referenciava
		events em PascalCase enquanto os domain-models misturavam convenções (uns
		PascalCase, outros prosa-com-espaços) e os nomes divergiam semanticamente.
		Mesmo escopando a relationships entre BCs construídos (built↔built), 7 de 16
		events não casavam — por divergência de nome, não ausência.

		Antes de qualquer gate, era preciso uma identidade canônica de event e
		reconciliar o vocabulário. Os 7 mismatches built↔built foram detalhados
		(producer, nome no domain-model, referência no context-map, consumers) e
		decididos caso-a-caso pelo founder — preferindo isso a aprovar a keystone às
		cegas e descobrir exceções depois.

		Alternativa REJEITADA: code (evt-*) como chave cross-artifact. Reprovada —
		menos legível num mapa de relationships e iria contra o grão (o spec fala em
		nomes; events são linguagem ubíqua). code permanece como id interno estável.
		"""

	decision: """
		(1) Identidade canônica de event:
		    - name PascalCase (sem espaços) é a CHAVE canônica cross-artifact.
		    - O BC PRODUTOR (contexts/<bc>/domain-model.cue events[]) é a Source of
		      Truth do event.
		    - code (evt-kebab) permanece como id interno estável, NÃO é chave
		      cross-artifact.
		    - Escopo de canonização: built BCs only. Events de BC PLANEJADO ficam
		      como forward-declaration (allowance) até materialização.

		(2) Reconciliação built↔built (7 mismatches), decisões do founder:
		    - #1 CounterpartyRiskAlertRaised → RiskAlertRaised (dropa "Counterparty";
		      producer rew já dá o contexto).
		    - #2 CounterpartyRiskAlertCleared → RiskAlertResolved (Cleared = Resolved).
		    - #3 Delivery Verified → DeliveryVerified (só convenção).
		    - #4 Evidence Recorded → EvidenceRecorded (só convenção).
		    - #5 IdentityVerificationCompleted → IdentityVerified (producer idc ganha).
		    - #6 NetworkParticipantOnboarded → ParticipantQualified (onboarding
		      operacional completo = Qualified, não Registered).
		    - #7 NetworkParticipantStatusChanged → eventos GRANULARES
		      (ParticipantSuspended, ParticipantTerminated, ParticipantReactivated);
		      não criar umbrella genérico que esconde semântica operacional.

		(3) Aplicação: normalizados os 4 names tocados nos domain-models (dlv: Delivery
		    Verified, Evidence Recorded; rew: Risk Alert Raised, Risk Alert Resolved);
		    atualizadas as referências no context-map (incl. expansão do umbrella para
		    granulares nas relationships npm→rew, npm→nim, npm→ssc; e nas relationships
		    de producer built mesmo com consumer planejado, p/ manter o nome do event
		    consistente em todas as ocorrências). code interno intacto (refs internas
		    usam code, não name — renames são display-only, seguros).

		FORA DE ESCOPO: o check events↔BC em si (próximo pass — precisa de allowance
		para producers planejados); normalização de convenção dos demais event names
		de dlv/rew (ex.: "Risk Alert Acknowledged (by authorized actor)") — limpeza
		separada, idealmente com um check que enforce PascalCase.
		"""

	consequences: """
		Positivas: (1) o vocabulário de events built↔built fica 100% consistente
		(7/7 casam) — fecha o drift de vocabulário real do audit; (2) identidade
		canônica registrada (name=chave, producer=SoT, code=interno) destrava o check
		sobre base limpa; (3) #7 preserva semântica operacional (granular vs umbrella
		genérico); (4) producer-as-SoT evita que consumers redefinam nomes.

		Negativas: (1) os demais event names de dlv/rew continuam em convenção
		inconsistente (limpeza separada) — built↔built consistente, mas BCs ainda
		internamente mistos; (2) renames de name são display-only mas, se algum
		artefato futuro referenciar event por name fora do regime atual, precisará
		seguir a chave canônica; (3) events de BC planejado seguem inconsistentes até
		materialização (esperado — forward-declaration).
		"""

	reversibility: "medium"
	blastRadius:   "repo-wide"

	affectedArtifacts: [
		"strategic/context-map.cue",
		"contexts/dlv/domain-model.cue",
		"contexts/rew/domain-model.cue",
	]

	principlesApplied: [
		"P0 — localização canônica única: o BC produtor é SoT do event; name é a chave; sem catálogo duplicado",
		"P10 — base para gate determinístico: vocabulário consistente é pré-requisito do check events↔BC",
		"adr-090 — derivar não duplicar: o namespace de events vem dos domain-models, não de catálogo autorado",
		"def-019 — reconciliação é o pré-requisito que o diagnóstico afiado identificou",
		"dp-07 — sem big-bang: built↔built primeiro; planned como forward-declaration; check no próximo pass",
	]

	defersTo: ["def-019"]

	rationale: """
		decisionClass structural: estabelece a identidade canônica de event
		(cross-artifact) e reconcilia context-map + 2 domain-models — decisão de
		vocabulário com efeito repo-wide, aplica P0/P10/adr-090 sem redefinir
		princípios. reversibility medium (renames + ref-updates reversíveis, mas
		desfazer toca 3 artefatos); blastRadius repo-wide (vocabulário de events).
		defersTo def-019 (o check em si).

		Verificado antes da proposta: os 7 mismatches detalhados e decididos pelo
		founder; renames são display-only (refs internas usam code evt-*, grep
		confirmou names não referenciados fora do domain-model); cue vet ./... EXIT 0;
		runner default → domain-invariant checks intactos, 0 bloqueantes, exit 0;
		protótipo → built↔built 0 missing (100% consistente) pós-reconciliação.
		"""
}
