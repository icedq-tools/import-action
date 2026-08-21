# icedq-tools/import-action

GitHub composite Action that imports an iceDQ rules or workflows bundle into a target workspace by invoking [`@icedq/cli`](https://www.npmjs.com/package/@icedq/cli).

Pairs with [`icedq-tools/export-action`](https://github.com/marketplace/actions/icedq-export) and [`icedq-tools/generate-mapping-action`](https://github.com/marketplace/actions/icedq-generate-mapping) for promotion pipelines.

## Usage

```yaml
- uses: actions/checkout@v4

- uses: icedq-tools/import-action@v1
  with:
    icedq-url:      ${{ secrets.ICEDQ_URL }}
    keycloak-url:   ${{ secrets.ICEDQ_KEYCLOAK_URL }}
    client-id:      ${{ secrets.ICEDQ_CLIENT_ID }}
    client-secret:  ${{ secrets.ICEDQ_CLIENT_SECRET }}
    org-id:         ${{ secrets.ICEDQ_ORG_ID }}
    account-id:     ${{ secrets.ICEDQ_ACCOUNT_ID }}
    workspace-id:   ${{ vars.PROD_WORKSPACE_ID }}
    bundle:         ./exports/finance.zip
    kind:           workflows
    mapping-file:   ./mappings/prod.json
    strict:         'true'
```

## Inputs

| Input | Required | Default | Description |
|---|---|---|---|
| `icedq-url` | yes | — | iceDQ instance base URL |
| `keycloak-url` | yes | — | Keycloak token endpoint base |
| `client-id` | yes | — | OAuth client ID |
| `client-secret` | yes | — | OAuth client secret |
| `org-id` | yes | — | Org ID |
| `account-id` | yes | — | Account ID |
| `workspace-id` | yes | — | Target workspace ID |
| `bundle` | yes | — | Path to the export ZIP |
| `kind` | yes | — | `rules` or `workflows` |
| `mapping-file` | yes | — | Path to the mapping JSON |
| `use-fqn` | no | `false` | Resolve by FQN instead of UUIDs |
| `strict` | no | `true` | Fail the workflow on any skipped rule |
| `terminate-on-conflict` | no | `false` | Cancel an active import and retry |
| `timeout` | no | `1800` | Polling timeout in seconds |
| `cli-version` | no | `latest` | Pin a specific `@icedq/cli` version |
| `verify-ssl` | no | `true` | Verify TLS |

## Outputs

| Output | Description |
|---|---|
| `task-id` | iceDQ `taskInstanceId` |
| `status` | Terminal status (`Completed`, `Terminated`, `Error`) |
| `skipped-count` | Number of skipped rules parsed from the log |

## Artifacts

The full import log is uploaded as a workflow artifact named `icedq-import-log` whenever the action runs (success or failure).

## Versioning

- `@v1` — recommended. Tracks the latest `v1.x.y` release; you automatically get bug fixes and non-breaking improvements.
- `@v1.0.0` — pins to an exact release. No automatic updates; upgrade by changing this yourself.
- `@<commit-sha>` — pins to an exact commit. Most reproducible/secure option.

Breaking changes are released under a new major tag (`@v2`, etc.) — existing `@v1` users are never moved onto breaking changes automatically.

## Self-hosted runners

For iceDQ instances on private networks, set `runs-on: [self-hosted, icedq]` (or your runner's labels). The Action is runner-agnostic.

## Related tools

- [`icedq-tools/cli`](https://www.npmjs.com/package/@icedq/cli) — the CLI this Action wraps
- [`icedq-tools/export-action`](https://github.com/marketplace/actions/icedq-export) — exports a bundle from the source workspace
- [`icedq-tools/generate-mapping-action`](https://github.com/marketplace/actions/icedq-generate-mapping) — generates the mapping file this Action consumes
