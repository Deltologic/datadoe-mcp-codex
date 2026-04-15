# DataDoe MCP + Codex Example

This repository is a minimal example of using the DataDoe MCP server from Codex for Amazon-focused workflows.

## Table of contents

- [What you can do with this repo](#what-you-can-do-with-this-repo)
- [What this repo is](#what-this-repo-is)
- [Prerequisites](#prerequisites)
- [How to start working with it](#how-to-start-working-with-it)
- [Launcher script manual](#launcher-script-manual)
- [Fallback: direct key in TOML](#fallback-direct-key-in-toml)
- [How to get a DataDoe subscription and get MCP Key](#how-to-get-a-datadoe-subscription-and-get-mcp-key)
- [How to get help](#how-to-get-help)
- [Recommended repository cleanup](#recommended-repository-cleanup)
- [Security roadmap](#security-roadmap)
- [Tags](#tags)

## What you can do with this repo

- Connect Codex to DataDoe MCP in a secure way.
- Ask Amazon seller questions using DataDoe-backed data.
- Reuse this setup as a template for new Amazon-focused assistant projects.

## What this repo is

- A starter setup for connecting Codex to DataDoe MCP.
- A reference for secure local API key configuration.
- A base project for asking Amazon selling questions through MCP in Codex.

## Prerequisites

Before using this setup, install at least one Codex runtime:

- Codex CLI:
  - `npm i -g @openai/codex`
- Codex Desktop app:
  - Install from [Codex App](https://developers.openai.com/codex/app)

## How to start working with it

1. Clone the repository:
   ```bash
   git clone https://github.com/Deltologic/datadoe-mcp-codex
   cd datadoe-mcp-codex
   ```
2. Copy `.env.example` to `.env` and set your real key:
   - `DATADOE_MCP_KEY=your_real_key_here`
3. Configure `.codex/config.toml` to use env-based headers (default, recommended):
   - `url = "https://api.datadoe.com/mcp/v1"`
   - `env_http_headers = { datadoe-mcp-key = "DATADOE_MCP_KEY" }`
4. Start the interactive launcher (it loads `.env` for you):
   - `./scripts/start-codex.sh`
5. In the launcher menu, choose:
   - `1` to open Codex CLI
   - `2` to open Codex Desktop app
6. Optional non-interactive shortcuts:
   - `./scripts/start-codex.sh --cli`
   - `./scripts/start-codex.sh --desktop`
   - `./scripts/start-codex.sh --check`
7. Verify MCP setup in Codex using `codex mcp` (or `/mcp` in TUI) and confirm `datadoe` is active.

## Launcher script manual

Script path:

- `./scripts/start-codex.sh`

What it does:

- Loads `DATADOE_MCP_KEY` from `.env`
- Provides interactive mode to choose Codex CLI or Codex Desktop
- Handles missing Codex CLI/Desktop with clear error hints

Interactive mode:

```bash
./scripts/start-codex.sh
```

Menu options:

- `1` launch Codex CLI
- `2` launch Codex Desktop app
- `3` exit safely

Flags:

- `--help` show script manual with colored output
- `--check` validate `.env` and key loading without launching Codex
- `--cli` launch Codex CLI directly
- `--desktop` launch Codex Desktop directly

Examples:

```bash
./scripts/start-codex.sh --help
./scripts/start-codex.sh --check
./scripts/start-codex.sh --cli
./scripts/start-codex.sh --desktop
```

## Fallback: direct key in TOML

If your environment cannot provide `DATADOE_MCP_KEY`, use direct key fallback in `.codex/config.toml`:

```toml
[mcp_servers.datadoe]
url = "https://api.datadoe.com/mcp/v1"
http_headers = { datadoe-mcp-key = "your_real_key_here" }
```

This fallback is less secure because the real secret is stored in the TOML file.

> [!CAUTION]
> Treat `DATADOE_MCP_KEY` like a password. Do not publish repositories, screenshots, or logs that contain this key.
> If a key is exposed, rotate it immediately.

## How to get a DataDoe subscription and get MCP Key

1. Go to [app.datadoe.com](https://app.datadoe.com).
2. Create an account.
3. Purchase a subscription.
4. Accept the Terms and Conditions and Privacy Policy.
5. Go to the `Integrations` module.
6. Click the `MCP` tile (this navigates to `/integrations/mcp`).
7. Click `MCP Key`, then add a name and expiration date, and click `Create`.
8. Copy the key and store it in a secure secret manager or another safe location.

## How to get help

- Email: [contact@datadoe.com](mailto:contact@datadoe.com)

## Recommended repository cleanup

For each repository using this template, keep settings lean:

- Disable GitHub Wiki if not used.
- Disable GitHub Projects if not used.
- Disable Discussions if not used.
- Keep branch protection minimal but enabled for your main branch.
- Do not commit `.env` or real API keys.

## Security roadmap

We are continuing work on even more secure key-passing options so users do not need to store real secrets directly in `.codex/config.toml`.

## Tags

`DataDoe` `MCP` `Codex` `Amazon` `Amazon Seller` `AI Assistant` `LLM` `Prompting`
