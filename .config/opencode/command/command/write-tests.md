# Write Tests for PR Changes

Analyze the current branch's changes against main and write appropriate test cases.

## Process

### 1. Analyze Changes
- Run `git diff main...HEAD --stat` to identify changed files
- Run `git diff main...HEAD` on relevant source files to understand what changed
- Focus on: services, providers, repositories, handlers, and business logic
- Identify the specific functionality added or modified

### 2. Discover Existing Test Patterns
Before writing any tests:
- Find existing test files for the changed code (e.g., `FooService.kt` -> `FooServiceTest.kt`)
- Read the entire test file to understand:
  - Mock setup patterns (`@MockK`, `mockk()`, `every {}`)
  - Test naming conventions
  - How test fixtures are created
  - Assertion patterns used
  - Any shared test utilities or base classes
- If no existing test file, find a similar test in the same package

### 3. Determine Test Approach
Choose the appropriate test type based on what's being tested:

**Unit tests** (mock dependencies):
- Pure business logic and calculations
- Service methods with mockable dependencies
- Validation logic
- State machine transitions

**Integration/Database tests** (use testcontainers):
- Repository methods
- Database queries and transactions
- End-to-end flows that touch the database
- When verifying data persistence is critical

Never skip testing because it's difficult. This is financial software - accuracy matters.

### 4. Present Test Plan
Before writing any code, show the user:
- List of test cases to be written
- Test approach for each (unit vs integration)
- Which existing patterns will be followed
- Any new test infrastructure needed

Wait for explicit approval before proceeding.

### 5. Write Tests
After approval:
- Follow existing patterns exactly
- Add tests to existing test files when possible
- Run tests to verify they pass

## Test Writing Principles

**Concise**: Tests should be short and readable. No unnecessary setup.

**Not clever**: Avoid complex abstractions. If the codebase doesn't have a fancy test utility, don't create one.

**Follow patterns**: Match the exact style of existing tests in the file. If they use `@MockK` annotations, use that. If they use inline `mockk()`, use that.

**Test functionality**: Focus on what the code does, not how it does it. Test inputs and outputs, not internal implementation.

**No shortcuts**: If something interacts with the database, write a database test. If it's a critical edge case, test it even if it's hard.

**Edge cases matter**: This code handles money. Test boundary conditions, zero values, precision edge cases, and failure modes.

## Anti-Patterns to Avoid

- Tests that just verify mocks were called (test behavior, not wiring)
- Overly verbose setup that obscures what's being tested
- Clever parameterized tests when simple explicit tests are clearer
- Testing private methods directly (test through public interface)
- Skipping tests because "it's hard to test"
