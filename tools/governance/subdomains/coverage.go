package main

import (
	"fmt"
	"sort"
)

func DeclaredFFIndex(suite *SubdomainSuite) (map[string]FitnessFunction, error) {
	index := make(map[string]FitnessFunction, len(suite.FitnessFunctions.Functions))

	for _, ff := range suite.FitnessFunctions.Functions {
		if _, exists := index[ff.ID]; exists {
			return nil, fmt.Errorf("fitness function duplicada no CUE: %s", ff.ID)
		}
		index[ff.ID] = ff
	}

	return index, nil
}

func ValidateFFCoverage(suite *SubdomainSuite) error {
	declared := map[string]bool{}
	for _, ff := range suite.FitnessFunctions.Functions {
		declared[ff.ID] = true
	}

	implemented := map[string]bool{}
	for id := range ImplementedChecks() {
		implemented[id] = true
	}

	var missingImpl []string
	for id := range declared {
		if !implemented[id] {
			missingImpl = append(missingImpl, id)
		}
	}

	var staleImpl []string
	for id := range implemented {
		if !declared[id] {
			staleImpl = append(staleImpl, id)
		}
	}

	sort.Strings(missingImpl)
	sort.Strings(staleImpl)

	if len(missingImpl) == 0 && len(staleImpl) == 0 {
		return nil
	}

	msg := "cobertura inconsistente entre CUE e Go"
	if len(missingImpl) > 0 {
		msg += fmt.Sprintf("; sem implementação Go: %v", missingImpl)
	}
	if len(staleImpl) > 0 {
		msg += fmt.Sprintf("; implementadas mas não declaradas no CUE: %v", staleImpl)
	}
	return fmt.Errorf("%s", msg)
}
