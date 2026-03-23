package main

import (
	"testing"
)

func TestValidMinimalFixture_NoBlockingFindings(t *testing.T) {
	suite, err := LoadSuiteFromFixture("../../../tests/fixtures/subdomains/valid/minimal")
	if err != nil {
		t.Fatalf("erro ao carregar fixture válida: %v", err)
	}

	if err := ValidateFFCoverage(suite); err != nil {
		t.Fatalf("coverage inconsistente: %v", err)
	}

	rawFindings := RunChecks(suite.Catalog.Subdomains)
	findings, err := MaterializeFindings(suite, rawFindings)
	if err != nil {
		t.Fatalf("erro ao materializar findings: %v", err)
	}

	blocking, _ := ApplyPolicy(suite.CIPolicy, findings, nil, fixedDate())

	if len(blocking) > 0 {
		for _, f := range blocking {
			t.Errorf("[FAIL] %s [%s]: %s", f.FF, f.Subdomain, f.Message)
		}
		t.Fatalf("fixture válida produziu %d findings blocking", len(blocking))
	}
}

func TestInvalidDuplicateBCFixture_TriggersFFSD02(t *testing.T) {
	suite, err := LoadSuiteFromFixture("../../../tests/fixtures/subdomains/invalid/duplicate-bc")
	if err != nil {
		t.Fatalf("erro ao carregar fixture inválida: %v", err)
	}

	rawFindings := RunChecks(suite.Catalog.Subdomains)

	found := false
	for _, rf := range rawFindings {
		if rf.FF == "ff-sd-02" {
			found = true
			break
		}
	}

	if !found {
		t.Fatalf("fixture duplicate-bc deveria disparar ff-sd-02, mas não disparou")
	}
}
