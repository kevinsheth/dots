# Personal Agent Rules

## Code Quality Standards

### No AI Slop
All code should look human-written. Remove:
- Extra comments inconsistent with file
- Defensive checks abnormal for that codebase area
- Casts to `any` to bypass type issues  
- Style inconsistent with surrounding code

### Testing Philosophy
- This is financial software - never skip tests because they're hard
- Follow existing patterns exactly, no clever abstractions
- Test edge cases: boundary conditions, zero values, precision, failure modes
- Integration tests for anything touching database

### Security Mindset
- Focus on what could go WRONG, not just happy paths
- LLMs tend toward optimistic thinking; be adversarial
- Flag uncertain areas for human review

## Token Optimization with rtk

ALWAYS use rtk for following operations to save 60-90% tokens:
- File operations: `rtk read` instead of read, `rtk ls` instead of ls
- Git operations: `rtk git status/diff/log/commit/push`
- Testing: `rtk test <command>` for failure-only output
- Errors: `rtk err <command>` for warnings/errors only
- Large outputs: `rtk summary <command>` for heuristic summaries
- Dependencies: `rtk deps` instead of package.json traversal
- Environment: `rtk env` for filtered vars

## Command Substitution Rules

### File Operations
- Use `rtk read <file>` - smart filtering with aggressive level
- Use `rtk ls <path>` - ultra-dense directory listings
- Use `rtk find <pattern>` - compact find results
- Use `rtk diff <file1> <file2>` - ultra-condensed diffs

### Git Operations
- Use `rtk git status` - compact status
- Use `rtk git diff` - condensed diffs
- Use `rtk git log -n 10` - one-line commits
- Use `rtk git add/commit/push/pull` - minimal output

### Development Operations
- Use `rtk test <command>` - failures only
- Use `rtk err <command>` - errors/warnings only
- Use `rtk json <file>` - structure without values
- Use `rtk summary <long-command>` - heuristic summary

## Fallback Protocol
If rtk command fails, retry with standard command once and report failure for visibility.

## Planning
At end of each plan, list concise unresolved questions. Maximum 3 questions.

## Available Skills

Use `load skill <name>` to activate:
- **deslop** - Remove AI-generated slop from changes
- **write-tests** - Write tests following existing patterns
- **security-review** - Security review for LLM-generated code
- **mentor** - Code review mentor (teaches without writing code)
- **verify-mocks** - Verify test mocks match production data
- **clean-agents** - Refactor AGENTS.md for progressive disclosure