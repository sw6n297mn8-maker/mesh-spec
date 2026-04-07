package shared_types

import "list"

// vertical-applicability.cue — Superfície de governança para
// aplicabilidade de artefatos por vertical de cadeia produtiva.
//
// Motivação: a tese Mesh declara que o padrão é agnóstico a
// cadeia produtiva específica (domain-definition.cue: "o padrão
// é transversal a qualquer cadeia B2B onde execução física gera
// evidência verificável"), mas artefatos individuais podem
// legitimamente embutir premissas da vertical inicial
// (construção civil brasileira). Sem superfície estrutural, a
// distinção entre "artefato genuinamente universal" e "artefato
// que parece universal mas embute construção civil" vive apenas
// em prosa e é descoberta por leitura humana.
//
// Este arquivo introduz dois tipos reutilizáveis consumidos por
// artefatos-alvo (ref adr-043): #VerticalClass (enum canônico
// fechado) e #VerticalApplicability (união discriminada por modo).
//
// Vocabulário mantido deliberadamente curto. Expansão via ADR.

// ═══════════════════════════════════════════════════════════════
// Enum canônico de verticais
// ═══════════════════════════════════════════════════════════════

// #VerticalClass — cadeias produtivas reconhecidas pelo sistema
// como eixos de diferenciação semântica de artefatos.
//
// Seis valores iniciais. Kebab-case para alinhar com o padrão
// já estabelecido em shared_types (core-subdomain, etc.).
//
// Intencionalmente ausente: "general-b2b-physical-execution".
// Universalidade dentro do recorte Mesh vive em
// #VerticalApplicability.mode == "vertical-agnostic", não como
// valor disfarçado no enum — evita ambiguidade por construção.
//
// Intencionalmente ausente: "industrial". Valor ambíguo que
// sobrepõe com construction, logistics e energy. Manufatura
// discreta é representada por "manufacturing".
//
// Expansão do enum exige ADR. Nunca adicionar valor via PR
// direto — a disciplina do vocabulário é o mecanismo que torna
// o campo útil para governança e consulta mecânica.
#VerticalClass:
	"construction" |
	"logistics" |
	"energy" |
	"agriculture" |
	"manufacturing" |
	"aerospace"

// ═══════════════════════════════════════════════════════════════
// Aplicabilidade por vertical
// ═══════════════════════════════════════════════════════════════

// #VerticalApplicability — declaração tipada de para quais
// verticais um artefato é semanticamente válido sem redefinição
// material.
//
// Modelado como união discriminada por mode, mesmo padrão
// usado em #ADR (status ↔ supersededBy) e #SelfReviewReport
// (status ↔ singleRoundRationale). A união impõe por construção
// quais campos são permitidos em cada modo.
//
// Semântica dos modos (valores em kebab-case por consistência
// com shared_types):
//
//   vertical-agnostic — artefato cujas premissas são válidas
//     para qualquer cadeia B2B com execução física verificável,
//     dentro do recorte Mesh. Não declara primaryVertical nem
//     validatedVerticals: universalidade não comporta "principal".
//     Rationale deve justificar POR QUE o artefato é universal —
//     tipicamente apontando que suas decisões derivam de
//     mecanismos canônicos do domain-definition (evidência,
//     gates determinísticos, SoTs) e não de práticas setoriais.
//
//   vertical-specific — artefato que embute premissas, vocabulário
//     ou mecanismos de UMA vertical específica. Declara
//     primaryVertical. Não declara validatedVerticals: se o
//     artefato se aplicasse a mais de uma, seria adaptable.
//     Rationale deve identificar quais premissas são
//     vertical-específicas.
//
//   vertical-adaptable — artefato com núcleo reutilizável cujos
//     pontos de variação por vertical estão explicitamente
//     declarados. Declara primaryVertical (a vertical base da
//     modelagem) e opcionalmente validatedVerticals (outras
//     verticais para as quais o artefato já foi explicitamente
//     validado — não intenção de extensão, evidência). Rationale
//     deve delinear qual parte é núcleo estável e qual parte
//     varia por vertical.
//
// Semântica estrita de validatedVerticals: o campo representa
// evidência, não intenção. Uma vertical só entra na lista após
// validação explícita do artefato contra as premissas daquela
// vertical. "Projetado para suportar" ≠ "validado para".
// Representação de intenção de extensão futura, caso necessária,
// deverá vir em campo separado via ADR posterior — juntar
// intenção e evidência no mesmo campo enfraquece a utilidade
// governável do tipo.
//
// Convenção enforçada pelo schema: validatedVerticals NÃO inclui
// primaryVertical. A cobertura total do artefato é
// {primaryVertical} ∪ validatedVerticals. A restrição é
// materializada via constraint de tipo de elemento
// (#VerticalClass & !=primaryVertical), não apenas comentário.
//
// Unicidade também enforçada via list.UniqueItems — drift
// duplicado na lista é bug de authoring, não estado válido.
//
// Rationale é obrigatório em todos os modos — classificar como
// agnostic, specific ou adaptable é uma micro-decisão de design
// que merece registro explícito. Inclusive (especialmente) em
// vertical-agnostic: declarar universalidade é exatamente a
// afirmação que mais carrega risco de falsa generalização.
#VerticalApplicability: _#VerticalApplicabilityBase & ({
	mode:                "vertical-agnostic"
	primaryVertical?:    _|_
	validatedVerticals?: _|_
} | {
	mode:                "vertical-specific"
	primaryVertical:     #VerticalClass
	validatedVerticals?: _|_
} | {
	mode:            "vertical-adaptable"
	primaryVertical: #VerticalClass
	validatedVerticals?: [#VerticalClass & !=primaryVertical, ...#VerticalClass & !=primaryVertical] & list.UniqueItems
})

// Base declara todos os campos do tipo. Os branches da união
// em #VerticalApplicability refinam (estreitam) cada campo
// conforme o modo. Mesmo padrão usado em #ADRBase ↔ #ADR.
_#VerticalApplicabilityBase: {
	mode:                "vertical-agnostic" | "vertical-specific" | "vertical-adaptable"
	primaryVertical?:    #VerticalClass
	validatedVerticals?: [...#VerticalClass]
	rationale:           string & !=""
}
