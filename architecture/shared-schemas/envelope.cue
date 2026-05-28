package shared_schemas

// envelope.cue — Envelope CloudEvents-like subset compartilhado cross-BC.
// Consolidação per def-022 (resolved): 2 consumidores reais (CMT, DLV)
// validaram o shape; extração do inline duplicado. NÃO é conformidade
// formal CloudEvents 1.0 — é subset Mesh-local.
//
// Money NÃO é consolidado aqui (DLV não usa); ver def-025 para deferimento
// do Money até 2º consumidor real materializar.
//
// ── DISCIPLINA DE FRONTEIRA (anti-stealth-extension) ──
//
// #Envelope é INTENTIONALLY MINIMAL. Campos adicionais do CloudEvents 1.0
// (subject, datacontenttype, etc.) ou metadata-de-mercado (traceparent,
// partitionKey, correlationId, etc.) NÃO devem ser adicionados localmente
// por BCs ao alias #Envelope nem ao shape compartilhado aqui. Qualquer
// expansão do envelope cross-BC exige:
//   1. tension-entry articulando a necessidade real (não conveniência);
//   2. revisita cross-BC dos consumidores existentes;
//   3. decisão explícita do founder antes da edição deste arquivo.
//
// Por quê isso importa: o maior risco operacional não é mesh-2 (versão);
// é um BC futuro "melhorar" o envelope sozinho adicionando subject ou
// traceparent e silenciosamente forkar a semântica cross-BC. Hoje o gate
// é cultural/documental (não há check estrutural pra isso ainda).

// #EnvelopeVersion: constante da versão atual.
//
// Pattern de coexistência futura: NÃO abrir disjunção aqui ("mesh-1" |
// "mesh-2") — isso afrouxaria o envelope e abriria porta pra drift. Quando
// mesh-2 surgir, criar #EnvelopeV2 num arquivo separado (envelope-v2.cue)
// com `envelopeVersion: "mesh-2"`; eventos legacy continuam usando
// #Envelope (mesh-1), novos usam #EnvelopeV2 — coexistência sem stealth-
// override do shape compartilhado.
#EnvelopeVersion: "mesh-1"

// #RFC3339Timestamp: helper reutilizável para timestamps RFC3339 (fração
// opcional + offset/Z). Usado em #Envelope.time e em campos de domínio
// CMT que também são RFC3339 (validatedAt, acceptedAt, etc.). DLV usa
// integer epoch pra timestamps de DOMÍNIO; este helper é só pra campos
// RFC3339 string.
#RFC3339Timestamp: string & =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}(\\.[0-9]+)?(Z|[+-][0-9]{2}:[0-9]{2})$"

// #Envelope: shape compartilhado cross-BC.
// - data NÃO está no base; cada evento adiciona data concretamente tipado.
// - `...` permite extensão por evento (data + campos específicos do tipo
//   do evento — NÃO permite override dos campos declarados aqui).
// - dataschema? permanece opcional: schema reference é hint discoverável;
//   obrigatoriedade é escolha per-evento (`dataschema: "..."` literal).
#Envelope: {
	id:              string & !=""
	source:          string & =~"^mesh://contexts/[a-z][a-z0-9-]*$"
	type:            string & !=""
	envelopeVersion: #EnvelopeVersion
	time:            #RFC3339Timestamp
	dataschema?:     string
	...
}
