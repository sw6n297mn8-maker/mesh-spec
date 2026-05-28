package shared_schemas

// money.cue — Money canonical shape compartilhado cross-BC.
// Consolidação per def-025 (resolved): 2 consumidores reais (CMT, INV)
// com shapes divergentes — CMT usou int em centavos, INV declarou
// decimal-string para audit-grade fiscal. Decisão: decimal-string vence
// por restrição mais forte (precision audit-grade + currency-agnostic
// minor-units; int centavos hard-coda escala 2-decimal e quebra para
// JPY 0-decimal / BHD 3-decimal). NÃO é conformidade formal a qualquer
// padrão monetário externo (ISO 4217 só cobre currency code).
//
// ── REPRESENTAÇÃO ──
//
// #DecimalString: string com regex strict `^(0|[1-9][0-9]*)(\.[0-9]+)?$`.
// - Não-negativo por construção do regex (sem `-?`). Valores negativos
//   (credit note, refund, adjustment, compensation) DEVEM ser modelados
//   como EVENTOS PRÓPRIOS, NÃO como Money com amount negativo silencioso.
// - Sem leading zeros no integer part: "01" rejeitado; "0" aceito;
//   "0.50" aceito; "100.5" aceito. Reduz divergência de representação
//   entre producers sem forçar scale fixa.
// - Sem max length: amounts arbitrarily-precision (audit fiscal pode
//   exigir centenas de dígitos em casos extremos; sem cap aqui).
//
// #Currency: string com regex `^[A-Z]{3}$` (ISO 4217 3-letter alpha).
// Separado como helper isolado para reuso futuro sem refactor cross-BC
// (analogous a #RFC3339Timestamp em envelope.cue). Hoje só Money usa.
//
// ── ESCALA NÃO NORMALIZADA POR DESIGN ──
//
// "0" e "0.00" são AMBOS válidos. "1" e "1.00" são AMBOS válidos.
// Canonical form (scale uniforme) NÃO é parte do contrato Money.
// Producer's choice: audit fiscal pode preferir scale explícita
// ("100.00") para sinalizar precisão declarada; outros usos podem
// minimizar ("100"). Consumers que precisam de equality semântica
// devem PARSEAR como decimal — comparação por string raw é incorreta.
//
// Esta stance deliberada porque escala canônica é currency/regime-
// dependent (BRL/USD 2 decimal; JPY 0; BHD/JOD 3; cripto até 18+) —
// fixar escala no schema cross-BC seria abstração prematura.
//
// ── DISCIPLINA DE FRONTEIRA (anti-stealth-extension) ──
//
// #Money é INTENTIONALLY MINIMAL (amount + currency). Campos adicionais
// — scale, unitOfMeasure, exchangeRate, asOfDate, presentationDecimals,
// originalAmount, baseCurrency, jurisdictionRef, etc. — NÃO devem ser
// adicionados localmente por BCs ao alias `#Money` nem ao shape
// compartilhado aqui. Qualquer expansão cross-BC exige:
//   1. tension-entry articulando a necessidade real (não conveniência);
//   2. revisita cross-BC dos consumidores existentes;
//   3. decisão explícita do founder antes da edição deste arquivo.
//
// Por que isso importa: o maior risco operacional não é precisão
// (decimal-string já é audit-grade); é um BC futuro "melhorar" Money
// sozinho adicionando scale ou unitOfMeasure e silenciosamente forkar
// a semântica cross-BC. Hoje o gate é cultural/documental (não há
// check estrutural pra isso ainda) — mesmo regime estabelecido para
// #Envelope em envelope.cue.

#DecimalString: string & =~"^(0|[1-9][0-9]*)(\\.[0-9]+)?$"
#Currency:      string & =~"^[A-Z]{3}$"

#Money: {
	amount:   #DecimalString
	currency: #Currency
}
