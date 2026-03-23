package main

import (
	"testing"
	"time"
)

func basePolicy() CIPolicy {
	return CIPolicy{
		Execution: ExecutionPolicy{
			Scope:     "full-catalog",
			Rationale: "test",
		},
		DefaultEnforcement: "blocking",
		Bootstrap: BootstrapPolicy{
			Mode:      "strict",
			Rationale: "test",
		},
		Reporting: ReportingPolicy{
			EmitSummary:      true,
			EmitPerFinding:   true,
			FailBuildOnError: true,
			Rationale:        "test",
		},
		Rationale: "test",
	}
}

func fixedDate() time.Time {
	return time.Date(2026, 3, 23, 12, 0, 0, 0, time.UTC)
}

func TestApplyPolicy_FailAndBlockingStayBlocking(t *testing.T) {
	policy := basePolicy()
	findings := []Finding{{FF: "ff-sd-01", Severity: "fail", Message: "x"}}

	blocking, warnings := ApplyPolicy(policy, findings, nil, fixedDate())

	if len(blocking) != 1 || len(warnings) != 0 {
		t.Fatalf("resultado inesperado")
	}
}

func TestApplyPolicy_RuleWarningOnlyDowngradesFail(t *testing.T) {
	policy := basePolicy()
	policy.Rules = []FitnessEnforcementRule{{
		FitnessID:   "ff-sd-01",
		Enforcement: "warning-only",
		Rationale:   "test",
	}}

	findings := []Finding{{FF: "ff-sd-01", Severity: "fail", Message: "x"}}

	blocking, warnings := ApplyPolicy(policy, findings, nil, fixedDate())

	if len(blocking) != 0 || len(warnings) != 1 {
		t.Fatalf("resultado inesperado")
	}
}

func TestApplyPolicy_WarnSeverityRemainsWarningEvenWhenDefaultBlocking(t *testing.T) {
	policy := basePolicy()
	findings := []Finding{{FF: "ff-sd-05", Severity: "warn", Message: "x"}}

	blocking, warnings := ApplyPolicy(policy, findings, nil, fixedDate())

	if len(blocking) != 0 || len(warnings) != 1 {
		t.Fatalf("resultado inesperado")
	}
}

func TestApplyPolicy_DefaultEnforcementAppliesWhenNoSpecificRuleExists(t *testing.T) {
	policy := basePolicy()
	policy.DefaultEnforcement = "warning-only"

	findings := []Finding{{FF: "ff-sd-06", Severity: "fail", Message: "x"}}

	blocking, warnings := ApplyPolicy(policy, findings, nil, fixedDate())

	if len(blocking) != 0 || len(warnings) != 1 {
		t.Fatalf("resultado inesperado")
	}
}

func TestApplyPolicy_BootstrapExceptionUntilDateDowngradesFail(t *testing.T) {
	policy := basePolicy()
	policy.Bootstrap = BootstrapPolicy{
		Mode: "grace-period",
		Exceptions: []BootstrapException{{
			FitnessID: "ff-sd-06",
			UntilDate: "2026-03-30",
			Rationale: "test bootstrap",
		}},
		Rationale: "test",
	}

	findings := []Finding{{FF: "ff-sd-06", Severity: "fail", Message: "x"}}

	blocking, warnings := ApplyPolicy(policy, findings, nil, fixedDate())

	if len(blocking) != 0 || len(warnings) != 1 {
		t.Fatalf("resultado inesperado")
	}
}

func TestBootstrapApplies_BothConditionsUseAND(t *testing.T) {
	policy := basePolicy()
	untilWave := uint(1)

	policy.Bootstrap = BootstrapPolicy{
		Mode: "grace-period",
		Exceptions: []BootstrapException{{
			FitnessID: "ff-sd-02",
			UntilWave: &untilWave,
			UntilDate: "2026-06-01",
			Rationale: "test bootstrap both",
		}},
		Rationale: "test",
	}

	currentWave := uint(2)
	applies := BootstrapApplies(policy, "ff-sd-02", &currentWave, time.Date(2026, 3, 1, 0, 0, 0, 0, time.UTC))
	if applies {
		t.Fatalf("bootstrap não deveria aplicar")
	}
}

func TestBootstrapApplies_WaveBoundExceptionFailsSafeWhenWaveMissing(t *testing.T) {
	policy := basePolicy()
	untilWave := uint(1)

	policy.Bootstrap = BootstrapPolicy{
		Mode: "grace-period",
		Exceptions: []BootstrapException{{
			FitnessID: "ff-sd-02",
			UntilWave: &untilWave,
			Rationale: "wave required",
		}},
		Rationale: "test",
	}

	applies := BootstrapApplies(policy, "ff-sd-02", nil, fixedDate())
	if applies {
		t.Fatalf("bootstrap não deveria aplicar")
	}
}
