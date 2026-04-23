---
description: Security review for LLM-generated changes
agent: general
---

Analyze the current branch's changes for security concerns specific to LLM-generated code.

## Process

### 1. Identify Changes
```bash
git diff main...HEAD  # or git diff for uncommitted
```

### 2. For Each Changed Function, Document:

#### A. Invariants
What MUST always be true?

```
PRE:  [condition that must hold before execution]
POST: [condition that must hold after execution]
LOOP: [condition preserved across iterations, if applicable]
```

#### B. Trust Boundaries
Where does data cross trust boundaries?

- External APIs / services
- User input (HTTP, CLI, file uploads)
- Database reads
- Environment variables / config
- Deserialized data (JSON, protobuf, etc.)

For each: What validation exists? What if it's malformed?

#### C. Failure Modes
What happens when:
- External call returns null/empty/error?
- Data is in unexpected format?
- Timeout or network failure?
- Concurrent modification?
- Resource exhaustion (memory, disk, connections)?

### 3. LLM Anti-Pattern Checklist

#### Null Safety
- [ ] Nullable values handled explicitly (not `!!` or implicit trust)
- [ ] Default values don't hide errors (`?: ""` or `?: 0` masking nulls)
- [ ] Optional/Maybe types unwrapped safely

#### Silent Failures  
- [ ] Exceptions not swallowed without logging
- [ ] Empty catch blocks justified
- [ ] Null returns don't mask errors

#### Type Safety
- [ ] No unsafe casts (`as`, type assertions)
- [ ] String-to-number conversions validated
- [ ] Enum parsing handles unknown values

#### Concurrency
- [ ] Shared mutable state protected
- [ ] Database operations atomic where needed
- [ ] No TOCTOU (time-of-check-time-of-use) races

#### Input Validation
- [ ] Bounds checking on arrays/indices
- [ ] Length limits on strings
- [ ] Range validation on numbers
- [ ] Format validation (emails, URLs, etc.)

### 4. Domain-Specific Concerns

#### If Financial Code:
- Can this cause funds loss?
- Can this enable double-spending?
- Is decimal precision correct?
- Are amounts validated before operations?

#### If Auth Code:
- Can this bypass authentication?
- Can this escalate privileges?
- Are secrets handled safely?
- Is session management correct?

#### If Data Code:
- Can this leak sensitive data?
- Is PII handled correctly?
- Are audit logs maintained?
- Is data sanitized before storage/display?

### 5. Fuzz Targets

List inputs that could be manipulated and their edge cases:

```
INPUT: [field name]
VALUES: null | empty | negative | MAX_INT | special chars | unicode | etc.
HANDLED: [yes/no and how]
```

### 6. Output

```markdown
## Security Assessment

### Summary
[One sentence: what does this change do?]

### Invariants
| Invariant | Enforced By | Location |
|-----------|-------------|----------|

### Trust Boundaries  
| Boundary | Data | Validation | Risk Level |
|----------|------|------------|------------|

### Fuzz Targets
| Input | Edge Cases | Handling |
|-------|------------|----------|

### Risks
- [ ] [SEVERITY] Description

### Verdict
[ ] SAFE - No significant risks
[ ] REVIEW - Minor concerns, human review recommended
[ ] BLOCK - Significant risks, requires fixes
```

## Notes

- Focus on what could go WRONG
- LLMs tend toward happy-path thinking; adversarial thinking is critical
- When uncertain, flag for human review
- This supplements, not replaces, human security review
