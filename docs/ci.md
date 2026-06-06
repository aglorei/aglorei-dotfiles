<!-- markdownlint-disable MD013 -->
# CI

## Workflow Overview

| Workflow | Triggers | Jobs |
|---|---|---|
| `build` | PR to `main`, push to `main`, weekly (Wed) | `yamllint`, `nix-flake-check` |
| `deploy` | `build` completes on `main` | `release-please` |
| `renovate` | Weekly (Mon), `workflow_dispatch` | `renovate` |
| `claude-code-review` | PR opened/updated | `claude-review` |
| `claude` | Issues opened/assigned, and issue/PR comments and reviews mentioning `@claude` | `claude` |

## CI/CD Flow

`build` runs on every PR and push to `main`. The `deploy` workflow triggers via `workflow_run` and gates on `build` concluding with `success`, so release-please only fires after a passing build.

Release management uses [release-please](https://github.com/googleapis/release-please) with `release-type: simple`. It reads Conventional Commit history to determine version bumps and generates `CHANGELOG.md` entries.

## Conventions

- **YAML linting** is CI-only. `.yamllint.yml` is the config; `build` is the authoritative check.
- **Flake validation** runs `nix flake check` via [DeterminateSystems/nix-installer-action](https://github.com/DeterminateSystems/nix-installer-action).
- **Claude workflows** require the `CLAUDE_CODE_OAUTH_TOKEN` secret.
- **Renovate** runs self-hosted via `renovatebot/github-action`, scoped to Nix only (`enabledManagers: ["nix"]`). It uses `GITHUB_TOKEN`, so PRs it opens do not automatically trigger `build` CI — run `build` manually via `workflow_dispatch` or the GitHub UI if validation is needed before merging. Dependabot handles `github-actions` updates separately and keeps `renovatebot/github-action` pinned.
