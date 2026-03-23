package main

import (
	"sort"
	"strings"
)

type CheckFunc func(map[string]Subdomain) []RawFinding

func ImplementedChecks() map[string]CheckFunc {
	return map[string]CheckFunc{
		"ff-sd-01": CheckFFSD01,
		"ff-sd-02": CheckFFSD02,
		"ff-sd-03": CheckFFSD03,
		"ff-sd-04": CheckFFSD04,
		"ff-sd-05": CheckFFSD05,
		"ff-sd-06": CheckFFSD06,
		"ff-sd-07": CheckFFSD07,
		"ff-sd-08": CheckFFSD08,
		"ff-sd-09": CheckFFSD09,
		"ff-sd-10": CheckFFSD10,
		"ff-sd-11": CheckFFSD11,
		"ff-sd-12": CheckFFSD12,
	}
}

func RunChecks(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	checks := ImplementedChecks()

	ids := make([]string, 0, len(checks))
	for id := range checks {
		ids = append(ids, id)
	}
	sort.Strings(ids)

	for _, id := range ids {
		out = append(out, checks[id](subdomains)...)
	}
	return out
}

func CheckFFSD01(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		for _, nb := range sd.NegativeBoundaries {
			if _, ok := subdomains[nb.DelegatedTo]; !ok {
				out = append(out, RawFinding{
					FF:        "ff-sd-01",
					Subdomain: code,
					Message:   "negativeBoundaries.delegatedTo referencia subdomínio inexistente: " + nb.DelegatedTo,
				})
			}
		}
		for _, p := range sd.Participants {
			if _, ok := subdomains[p.Ref]; !ok {
				out = append(out, RawFinding{
					FF:        "ff-sd-01",
					Subdomain: code,
					Message:   "participants.ref referencia subdomínio inexistente: " + p.Ref,
				})
			}
		}
		if sd.Deprecation != nil {
			for _, ref := range sd.Deprecation.AbsorbedBy {
				if _, ok := subdomains[ref]; !ok {
					out = append(out, RawFinding{
						FF:        "ff-sd-01",
						Subdomain: code,
						Message:   "deprecation.absorbedBy referencia subdomínio inexistente: " + ref,
					})
				}
			}
		}
	}
	return out
}

func CheckFFSD02(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	owners := map[string][]string{}

	for code, sd := range subdomains {
		if sd.Status != "active" {
			continue
		}
		for _, bc := range sd.BoundedContexts {
			owners[bc.Ref] = append(owners[bc.Ref], code)
		}
	}

	for bc, subs := range owners {
		if len(subs) > 1 {
			sort.Strings(subs)
			out = append(out, RawFinding{
				FF:      "ff-sd-02",
				Message: "bounded context " + bc + " aparece em múltiplos subdomínios ativos: " + strings.Join(subs, ", "),
			})
		}
	}

	return out
}

func CheckFFSD03(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		for _, layer := range sd.CrossCuttingLayers {
			if layer == sd.StrategicLayer {
				out = append(out, RawFinding{
					FF:        "ff-sd-03",
					Subdomain: code,
					Message:   "crossCuttingLayers contém a própria strategicLayer: " + layer,
				})
			}
		}
	}
	return out
}

func CheckFFSD04(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		if sd.Status == "active" && sd.Type == "core" && len(sd.MechanismRefs) == 0 {
			out = append(out, RawFinding{
				FF:        "ff-sd-04",
				Subdomain: code,
				Message:   "core ativo sem mechanismRefs",
			})
		}
	}
	return out
}

func CheckFFSD05(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		if sd.Status == "active" && sd.Type == "supporting" && len(sd.MechanismRefs) == 0 {
			out = append(out, RawFinding{
				FF:        "ff-sd-05",
				Subdomain: code,
				Message:   "supporting ativo sem mechanismRefs",
			})
		}
	}
	return out
}

func CheckFFSD06(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		if sd.Status == "active" && sd.Type == "core" && len(sd.MoatTypes) == 0 {
			out = append(out, RawFinding{
				FF:        "ff-sd-06",
				Subdomain: code,
				Message:   "core ativo sem moatTypes",
			})
		}
	}
	return out
}

func CheckFFSD07(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		if sd.Status == "active" && sd.Type != "generic" && len(sd.BusinessOutcomes) == 0 {
			out = append(out, RawFinding{
				FF:        "ff-sd-07",
				Subdomain: code,
				Message:   "subdomínio ativo não-generic sem businessOutcomes",
			})
		}
	}
	return out
}

func CheckFFSD08(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		if sd.Status != "deprecated" {
			continue
		}
		if sd.Deprecation == nil || len(sd.Deprecation.AbsorbedBy) == 0 {
			out = append(out, RawFinding{
				FF:        "ff-sd-08",
				Subdomain: code,
				Message:   "deprecated sem absorbedBy",
			})
		}
		if sd.Deprecation == nil || strings.TrimSpace(sd.Deprecation.Reason) == "" {
			out = append(out, RawFinding{
				FF:        "ff-sd-08",
				Subdomain: code,
				Message:   "deprecated sem reason",
			})
		}
	}
	return out
}

func CheckFFSD09(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		for _, p := range sd.Participants {
			if p.Ref == code {
				out = append(out, RawFinding{
					FF:        "ff-sd-09",
					Subdomain: code,
					Message:   "participants.ref referencia o próprio subdomínio",
				})
			}
		}
	}
	return out
}

func CheckFFSD10(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		for _, nb := range sd.NegativeBoundaries {
			if nb.DelegatedTo == code {
				out = append(out, RawFinding{
					FF:        "ff-sd-10",
					Subdomain: code,
					Message:   "negativeBoundary delega para si mesmo",
				})
			}
		}
	}
	return out
}

func CheckFFSD11(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	for code, sd := range subdomains {
		if sd.Status == "active" && len(sd.BoundedContexts) == 0 {
			out = append(out, RawFinding{
				FF:        "ff-sd-11",
				Subdomain: code,
				Message:   "subdomínio ativo sem boundedContexts",
			})
		}
	}
	return out
}

func CheckFFSD12(subdomains map[string]Subdomain) []RawFinding {
	var out []RawFinding
	activeCodes := map[string]bool{}
	for code, sd := range subdomains {
		if sd.Status == "active" {
			activeCodes[code] = true
		}
	}

	for code, sd := range subdomains {
		for _, alias := range sd.Aliases {
			if alias != code && activeCodes[alias] {
				out = append(out, RawFinding{
					FF:        "ff-sd-12",
					Subdomain: code,
					Message:   "alias colide com code ativo de outro subdomínio: " + alias,
				})
			}
		}
	}
	return out
}
