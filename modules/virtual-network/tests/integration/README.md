# Integration tests

Real-Azure tests (`*.tftest.hcl`, no mocks, OIDC-authenticated) go here. They are NOT
run by `make test`; CI runs them via `make test-integration` with credentials.
See `standards/testing.md` for what belongs here vs unit tests.
