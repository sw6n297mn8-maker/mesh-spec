package work_events

// wi-043.cue -- Stream de WI-043 (bootstrap de dominio do BC FCE).
//
// FECHAMENTO RETROATIVO POR RECONCILIACAO (2026-07-30). O trabalho foi
// executado e esta no disco; o task-completed nunca foi emitido. Este
// evento fecha a lacuna de REGISTRO -- nao registra uma conclusao que
// aconteceu hoje.
//
// AUTORIZACAO: reconciliacao decidida explicitamente pelo founder na
// sessao de 2026-07-30. O actor do evento e spec-writer porque o command
// CompleteTask e direito de spec-writer per command-rights.cue; hoje NAO
// existe command de reconciliacao com direito de founder. Essa lacuna de
// autoridade e um dos motivos do ADR do task-reconciled -- ver abaixo.
//
// ── REPURPOSE DOS 3 CAMPOS DE completionValidation ──────────────────
// Ler ANTES de interpretar os valores. O schema #CompletionValidation
// foi desenhado para fechamento no ato da conclusao, com gates rodados
// sobre o artefato recem-produzido. Aqui os tres campos carregam OUTRA
// coisa:
//
//   validationRunId -- identifica a RECONCILIACAO (varredura de
//   2026-07-30 sobre os 26 WIs abertos/orfaos), nao uma execucao de
//   validacao contemporanea a conclusao do WI.
//
//   artifactSnapshotHash -- carrega o tree da VERIFICACAO (2e96a21, o
//   estado em que os 5 outputs foram conferidos presentes), NAO o
//   snapshot do commit que concluiu o trabalho. Esse commit e
//   indeterminavel: o historico anterior foi achatado no squash do
//   baseline (3351afb, 1352 arquivos / 195.715 insercoes), a mesma
//   limitacao que def-029 ja registrava ("datacao por git indisponivel").
//
//   gatesPassed -- o marcador retroactive-disk-verification declara o
//   que DE FATO foi feito: conferencia de presenca dos 5 outputs
//   declarados na task-spec contra o disco. Os demais gates da lista
//   rodaram sobre ESTE commit de reconciliacao, nao sobre a conclusao do
//   WI. Nenhum gate contemporaneo a conclusao e reconstituivel.
//
// ── EVIDENCIA DA CONCLUSAO ──────────────────────────────────────────
// Escopo da task-spec WI-043 e exaustivo e nominal (5 outputs nomeados,
// ordem de producao declarada, sem linguagem de fan-out). Conferidos
// presentes em 2e96a21:
//   contexts/fce/canvas.cue                              ( 982 linhas)
//   contexts/fce/glossary.cue                            ( 431 linhas)
//   contexts/fce/domain-model.cue                        (1009 linhas)
//   contexts/fce/agents/fce-primary-agent.cue            ( 561 linhas)
//   contexts/fce/agents/fce-primary-agent.governance.cue ( 245 linhas)
// 5/5. A verificacao prova PRESENCA E SUBSTANCIA, nao data de conclusao.
//
// ── LACUNA CONHECIDA, NAO CORRIGIDA AQUI ────────────────────────────
// O claim de 2026-06-12 expirou em 2026-06-13T00:45:00Z e o
// task-claim-expired nunca foi emitido -- a transicao claimed→unclaimed
// existe no motor (work-governance.cue) e nao tem enforcement. Item
// proprio, deixado FORA desta fatia por decisao do founder (2026-07-30);
// nao entra no ADR do task-reconciled.
//
// ── PRECEDENTE CONTRARIO, DECLARADO ─────────────────────────────────
// Este repo ja encarou a pergunta "fabricar evento retroativo ou
// documentar?" e escolheu DOCUMENTAR em tres ocasioes: (1) WI-015, per
// nota de bootstrap em event-validation.cue + ADR-024; (2) fatia-1 do
// WI-140 (contexts/cmt/aggregate-manifests/am-commitment.cue, PR #124),
// cujo stream declara "nao ha evento retroativo: o trabalho ja esta
// auditavel via PR #124"; (3) o proprio cabecalho do stream wi-140.
// Esta reconciliacao DIVERGE desses precedentes por decisao explicita do
// founder, e o faz com o repurpose acima declarado em voz alta em vez de
// silencioso. A GENERALIZACAO do mecanismo (eventType task-reconciled,
// com direito de comando exclusivo do founder) NAO entra aqui: depende
// de ADR proprio, que tera de se posicionar contra os tres precedentes.
//
// ── ERRATUM (2026-08-01) — a narrativa de precedente acima esta ERRADA ──
// Correcao por nota datada: o texto original permanece intacto acima, para
// que o que foi afirmado siga auditavel. Nao ha edicao retroativa.
//
// (a) O QUE FOI AFIRMADO: que este repo encarou a pergunta "fabricar evento
//     retroativo ou documentar?" e escolheu DOCUMENTAR em TRES ocasioes,
//     sendo a primeira "WI-015, per nota de bootstrap em event-validation.cue
//     + ADR-024".
//
// (b) O QUE A VERIFICACAO DE 2026-08-01 ESTABELECEU (review isolado do
//     adr-183, per rollout adr -> isolated-subagent de quality-gate.cue, com
//     conferencia na fonte):
//     - Sao DUAS ocasioes, nao tres. Os itens (2) e (3) da enumeracao acima
//       sao a MESMA ocasiao: a nota de pre-registro da fatia-1 e a frase
//       citada ocupam um bloco unico no cabecalho de work-events/wi-140.cue.
//     - O adr-024 e precedente INVERTIDO. Seu decision item (3) decidiu
//       "work-events/ -- diretorio de streams + backfill retroativo de
//       tarefas ja concluidas com timestamps extraidos do git log": decidiu
//       FABRICAR evento retroativo, nao documentar. A nota de bootstrap em
//       event-validation.cue trata de ESCOPO DE VALIDACAO DE CI ("CI nao os
//       valida retroativamente"), nao de emitir ou nao emitir evento -- as
//       duas coisas foram lidas como uma so, e nao sao.
//     - Estado de coisas real do repo: 65 streams em
//       governance/build-time/work-events/ carregam commandIds sufixados
//       -backfill, e wi-001.cue traz task-approved com actor "founder" e
//       commandId "WI-001-approve-backfill". Fabricar cadeia de aprovacao
//       retroativa e pratica sancionada e executada aqui -- nao excecao.
//
// (c) O QUE PERMANECE VALIDO: o task-completed abaixo, e a evidencia de disco
//     que o justifica. A conferencia dos 5 outputs do WI-043 em 2e96a21 nao
//     foi afetada; o erro estava na NARRATIVA DE PRECEDENTE do cabecalho, nao
//     no fato registrado nem no repurpose declarado dos tres campos de
//     completionValidation. Nenhum evento e revogado por esta nota.
//
// ORIGEM DO ERRO: apuracao rasa na sessao de 2026-07-30 -- o adr-024 foi
// invocado sem leitura do seu decision item, e os backfills existentes nao
// foram contados antes da afirmacao. A afirmacao ATRAVESSOU a aprovacao do
// founder no PR #225 e foi depois REUTILIZADA como premissa do Gate 2 do
// adr-183: nem a autoria nem a aprovacao verificaram as ancoras. O achado
// veio do review isolado, instruido a conferir citacoes contra a fonte -- o
// gate humano nao pegou. Registro deliberado: a camada de revisao que
// funcionou aqui foi a isolada, nao a do autor nem a do aprovador.
//
// A reformulacao do adr-183 (fatia propria) parte do estado de coisas
// correto: bootstrap vs steady state, com task-reconciled como sucessor
// honesto do backfill.

streams: {
	"WI-043": {
		events: [{
			eventType:   "task-proposed"
			taskId:      "WI-043"
			taskVersion: 1
			commandId:   "WI-043-propose-bc-bootstrap"
			timestamp:   "2026-04-06T18:00:00Z"
			actor:       "spec-writer"
		}, {
			eventType:   "task-approved"
			taskId:      "WI-043"
			taskVersion: 1
			commandId:   "WI-043-approve-bc-bootstrap"
			timestamp:   "2026-04-06T18:01:00Z"
			actor:       "founder"
		}, {
			eventType:      "task-claimed"
			taskId:         "WI-043"
			taskVersion:    1
			commandId:      "WI-043-claim-fatia-guard-path"
			timestamp:      "2026-06-12T16:45:00Z"
			actor:          "spec-writer"
			claimExpiresAt: "2026-06-13T00:45:00Z"
		}, {
			eventType:   "task-completed"
			taskId:      "WI-043"
			taskVersion: 1
			commandId:   "WI-043-complete-fce-bootstrap-reconciliation"
			timestamp:   "2026-07-30T19:42:10Z"
			actor:       "spec-writer"
			completionValidation: {
				validationRunId:      "reconciliation-20260730"
				artifactSnapshotHash: "2e96a21"
				gatesPassed: ["retroactive-disk-verification", "cue-vet", "structural-runner", "freshness-gate", "check-self-review"]
			}
		}]
	}
}
