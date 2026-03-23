package main

import "fmt"

func MaterializeFindings(suite *SubdomainSuite, raw []RawFinding) ([]Finding, error) {
	ffIndex, err := DeclaredFFIndex(suite)
	if err != nil {
		return nil, err
	}

	out := make([]Finding, 0, len(raw))
	for _, rf := range raw {
		ff, ok := ffIndex[rf.FF]
		if !ok {
			return nil, fmt.Errorf("finding referencia fitness function não declarada: %s", rf.FF)
		}

		out = append(out, Finding{
			FF:        rf.FF,
			Severity:  ff.Severity,
			Subdomain: rf.Subdomain,
			Message:   rf.Message,
		})
	}

	return out, nil
}
