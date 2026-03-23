package main

import (
	"fmt"
	"sort"
	"time"
)

/*
SEMÂNTICA CRÍTICA:

- Severity vem do CUE e define o TETO de gravidade.
- Policy pode REBAIXAR (fail → warning).
- Policy NÃO pode PROMOVER (warn → fail).
*/
func ApplyPolicy(policy CIPolicy, findings []Finding, currentWave *uint, currentDate time.Time) (blocking []Finding, warnings []Finding) {
	for _, f := range findings {
		enforcement := EnforcementFor(policy, f.FF)

		if BootstrapApplies(policy, f.FF, currentWave, currentDate) {
			enforcement = "warning-only"
		}

		f.Enforcement = enforcement

		if enforcement == "warning-only" || f.Severity == "warn" {
			warnings = append(warnings, f)
		} else {
			blocking = append(blocking, f)
		}
	}

	return
}

func PrintReport(policy CIPolicy, blocking []Finding, warnings []Finding) {
	sort.Slice(blocking, func(i, j int) bool {
		if blocking[i].FF == blocking[j].FF {
			return blocking[i].Subdomain < blocking[j].Subdomain
		}
		return blocking[i].FF < blocking[j].FF
	})

	sort.Slice(warnings, func(i, j int) bool {
		if warnings[i].FF == warnings[j].FF {
			return warnings[i].Subdomain < warnings[j].Subdomain
		}
		return warnings[i].FF < warnings[j].FF
	})

	if policy.Reporting.EmitPerFinding {
		for _, f := range blocking {
			fmt.Printf("[FAIL] %s", f.FF)
			if f.Subdomain != "" {
				fmt.Printf(" [%s]", f.Subdomain)
			}
			fmt.Printf(": %s\n", f.Message)
		}
		for _, f := range warnings {
			fmt.Printf("[WARN] %s", f.FF)
			if f.Subdomain != "" {
				fmt.Printf(" [%s]", f.Subdomain)
			}
			fmt.Printf(": %s\n", f.Message)
		}
	}

	if policy.Reporting.EmitSummary {
		fmt.Println()
		fmt.Printf("Summary: %d blocking, %d warnings\n", len(blocking), len(warnings))
	}
}
