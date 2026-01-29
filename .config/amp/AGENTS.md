# Personal Agent Rules

## Code Quality Standards

### No AI Slop
All code should look human-written. Remove:
- Extra comments inconsistent with the file
- Defensive checks abnormal for that codebase area
- Casts to `any` to bypass type issues  
- Style inconsistent with surrounding code

### Testing Philosophy
- This is financial software - never skip tests because they're hard
- Follow existing patterns exactly, no clever abstractions
- Test edge cases: boundary conditions, zero values, precision, failure modes
- Integration tests for anything touching the database

### Security Mindset
- Focus on what could go WRONG, not just happy paths
- LLMs tend toward optimistic thinking; be adversarial
- Flag uncertain areas for human review

## Available Skills

Use `load skill <name>` to activate:
- **deslop** - Remove AI-generated slop from changes
- **write-tests** - Write tests following existing patterns
- **security-review** - Security review for LLM-generated code
- **mentor** - Code review mentor (teaches without writing code)
- **verify-mocks** - Verify test mocks match production data
- **clean-agents** - Refactor AGENTS.md for progressive disclosure
