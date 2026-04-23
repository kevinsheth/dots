---
description: Verify test mocks match production/staging data
agent: general
---

Validate that test mock assumptions match real data in a live environment.

## Process

### 1. Identify Mocked Data in Tests

Search for mocking patterns in the codebase:

```bash
# Common patterns to search for
grep -r "mock\|Mock\|every\s*{" src/test --include="*.kt" --include="*.java" --include="*.ts" --include="*.py" -l
grep -r "jest.mock\|vi.mock\|@Mock\|mockk\|patch\|MagicMock" src/test -l
```

For each test file found:
1. Identify what external data is being mocked (API responses, database records, config values)
2. Extract the specific values being assumed (IDs, amounts, statuses, flags)
3. Note the source of truth for that data (database, external API, config service)

### 2. Determine How to Query Real Data

Based on the source of truth, identify verification method:

| Source | Verification Method |
|--------|---------------------|
| Database | Direct query or admin API |
| External API | Playground/CLI tool, or curl |
| Config service | Config API or environment query |
| Third-party service | May need staging credentials |

If no existing tool exists to query the data:
1. Check for a playground, CLI, or REPL in the repo
2. Check for admin APIs or debug endpoints
3. As last resort, write a temporary script

### 3. Extract and Compare

For each mocked value:

```
| Location | Mocked Value | Actual Value | Match? |
|----------|--------------|--------------|--------|
| UserServiceTest.kt:45 | status="ACTIVE" | status="ACTIVE" | ✅ |
| OrderServiceTest.kt:102 | price=100.00 | price=99.95 | ⚠️ Close |
| AssetCacheTest.kt:23 | symbol="FOO" | NOT FOUND | ❌ |
```

### 4. Categorize Mismatches

**Critical** - Test assumes data that doesn't exist:
- Mocked ID/symbol not found in live system
- Mocked enum value not valid

**Warning** - Values differ but test may still be valid:
- Numeric values slightly different (precision, rounding)
- Timestamps or generated IDs

**Acceptable** - Intentional test isolation:
- Error case mocks (testing failure paths)
- Edge case values that shouldn't exist in prod

### 5. Fix or Document

For each mismatch:
1. **If mock is wrong**: Update to match reality
2. **If reality changed**: Update mock and verify test intent still holds
3. **If intentional**: Add comment explaining why mock differs from prod

### 6. Report

```
=== Mock Verification Report ===

Scanned: X test files
Mocked values found: Y
Verified against: [environment name]

✅ Matches: N
⚠️ Warnings: N  
❌ Mismatches: N

Critical Issues:
- [file:line] Mocked "X" but actual value is "Y"
- [file:line] Symbol "Z" not found in [environment]

Recommendations:
- Update [file] to use actual values from [environment]
- Add data setup for missing entities
```

## Common Pitfalls

- **ID formats**: UUIDs vs numeric IDs vs slugs - formats may differ between environments
- **Nullable fields**: Mock may assume field exists, but it's null/missing in prod
- **Default values**: Proto/JSON may omit defaults (false, 0, empty string)
- **Environment-specific data**: Some data only exists in certain environments
- **Stale snapshots**: Mocks copied from prod months ago may be outdated

## When to Run

- Before merging PRs that add/modify test mocks
- When tests pass locally but behavior differs in staging/prod  
- After external data sources change (API updates, schema migrations)
- Periodically as part of test maintenance

## Automation Ideas

Consider adding to CI:
```yaml
# Nightly job to validate mocks haven't drifted
- name: Verify test mocks
  run: ./scripts/verify-mocks.sh --env staging
  continue-on-error: true  # Alert but don't block
```
