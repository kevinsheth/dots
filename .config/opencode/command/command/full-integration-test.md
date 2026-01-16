---
description: Dynamic e2e test based on branch changes
agent: general
---

Run a full integration test based on what changed in this branch.

## Steps

1. **Analyze changes**: `git diff --name-only origin/main...HEAD` - categorize by type:
   - **gRPC handler**: e2e testable via grpcurl
   - **Service called by handler**: e2e testable via the handler
   - **Service called by background job**: unit test only (skip e2e)
   - **Proto**: verify enum/message via file, not grpcurl (shared types not exposed)
   - **Migration**: verify via DB query

2. **Trace impact**: Search for *method names* not class names (classes may not be directly imported). Check `**/job/*.kt` for background job callers.

3. **Reset infra** (use working_directory, not cd):
   ```
   working_directory: /path/to/repo/local
   command: docker-compose down -v && docker-compose up -d
   ```

4. **Start server**: Kill port 8080, run `./gradlew :server:bootRun > /tmp/server.log 2>&1 &` in background, poll with grpcurl until ready

5. **Create test data** (standard setup):
   ```bash
   # Register custodian
   grpcurl -plaintext -d '{"name": "test-custodian", "account_address": "tp1...", "collateral_market_id": "1", "user_address": "tp1..."}' localhost:8080 farkets.cbl.admin.v1.service.custodian.CustodianService/RegisterCustodian
   
   # Activate custodian (no admin API - must update DB directly)
   docker exec postgres psql -U postgres -d service-cbl -c "UPDATE \"service-cbl\".custodian SET status = 'ACTIVE' WHERE name = 'test-custodian';"
   
   # Register user
   grpcurl -plaintext -H 'x-custodian-name: test-custodian' -d '{"id": "test-user-001", "account_address": "tp1..."}' localhost:8080 farkets.cbl.external.v1.service.user.UserService/GetOrRegisterUserWithCustodian
   
   # Register loan
   grpcurl -plaintext -H 'x-custodian-name: test-custodian' -d '{"id": "test-loan-001", "user_id": "test-user-001"}' localhost:8080 farkets.cbl.external.v1.service.loan.LoanService/RegisterLoanWithUser
   ```

6. **Test affected endpoints**: Only if change is in gRPC handler or service called by handler. Skip for background job logic.

7. **Verify DB state**: `docker exec postgres psql -U postgres -d service-cbl -c 'SELECT ... FROM "service-cbl".<table>;'`

8. **Check logs**: `tail -100 /tmp/server.log | grep -i error` - ignore Kafka/Blockapi errors (external services)

9. **Client SDK** (if changed): Verify SDK methods match proto fields

10. **Report**: List what was tested, pass/fail, note if change was unit-test-only (background job logic)
