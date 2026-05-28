# icedq/import-action

GitHub composite Action that imports an iceDQ rules or workflows bundle into a target workspace by invoking [`@icedq/cli`](https://www.npmjs.com/package/@icedq/cli).

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

## Self-hosted runners

For iceDQ instances on private networks, set `runs-on: [self-hosted, icedq]` (or your runner's labels). The Action is runner-agnostic.

## Companion repos

- [`icedq/cli`](https://github.com/icedq/cli) — the CLI this Action wraps
- `icedq/export-action`, `icedq/validate-action` — coming in v0.2
