.PHONY: frontend-lint frontend-typecheck frontend-format-check backend-fmt-check backend-lint test check

frontend-lint:
	@if [ -f frontend/package.json ]; then \
		cd frontend && npm run lint; \
	else \
		echo "Frontend not present yet - skipping ESLint"; \
	fi

frontend-typecheck:
	@if [ -f frontend/package.json ]; then \
		cd frontend && npm run typecheck; \
	else \
		echo "Frontend not present yet - skipping TypeScript check"; \
	fi

frontend-format-check:
	@if [ -f frontend/package.json ]; then \
		cd frontend && npm run format:check; \
	else \
		echo "Frontend not present yet - skipping Prettier check"; \
	fi

backend-fmt-check:
	@UNFORMATTED="$$(find backend -type f -name '*.go' -exec gofmt -l {} +)"; \
	if [ -n "$$UNFORMATTED" ]; then \
		echo "Go files are not formatted:"; \
		echo "$$UNFORMATTED"; \
		exit 1; \
	fi
	@echo "Backend formatting OK"

backend-lint:
	cd backend && go vet ./...
	@echo "Backend vet OK"

test:
	cd backend && go test ./...

check: frontend-lint frontend-typecheck frontend-format-check backend-fmt-check backend-lint test
	@echo "All available checks passed."
