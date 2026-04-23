# DataDoe MCP + Codex Integration Project Template

This repository is a minimal example of using the DataDoe MCP server from Codex for Amazon-focused workflows.

## Table of contents

- [What you can do with this repo](#what-you-can-do-with-this-repo)
- [What This Repo Includes](#what-this-repo-includes)
- [Prerequisites](#prerequisites)
- [How to get a DataDoe subscription and get MCP Key](#how-to-get-a-datadoe-subscription-and-get-mcp-key)
- [How to start working with it](#how-to-start-working-with-it)
- [Example prompt library starter pack](#example-prompt-library-starter-pack)
- [Run Codex from Dedicated Launcher](#run-codex-from-dedicated-launcher)
- [Fallback: direct key in TOML](#fallback-direct-key-in-toml)
- [How to get help](#how-to-get-help)

## What you can do with this repo

- Connect Codex to DataDoe MCP in a secure way.
- Ask Amazon seller questions using DataDoe-backed data.
- Reuse this setup as a template for new Amazon-focused assistant projects.

## What This Repo Includes

- Codex CLI + MCP integration guidance for a project-scoped `datadoe` server
- Secure secret handling with `.env` and `.env.example`
- Repository-specific assistant rules in `AGENTS.md`

## Prerequisites

Before using this setup, install at least one Codex runtime:

- Codex CLI:
  ```bash
  npm i -g @openai/codex
  ```
- Codex Desktop app:
  - Install from [Codex App](https://developers.openai.com/codex/app)

## How to get a DataDoe subscription and get MCP Key

1. Go to [app.datadoe.com](https://app.datadoe.com).
2. Create an account.
3. Purchase a subscription.
4. Accept the Terms and Conditions and Privacy Policy.
5. Go to the `Integrations` module.
6. Click the `MCP` tile (this navigates to `/integrations/mcp`).
7. Click `MCP Key`, then add a name and expiration date, and click `Create`.
8. Copy the key and store it in a secure secret manager or another safe location.

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
   ```bash
   ./scripts/start-codex.sh
   ```
5. In the launcher menu, choose:
   - `1` to open Codex CLI
   - `2` to open Codex Desktop app
6. Optional non-interactive shortcuts:
   - `./scripts/start-codex.sh --cli`
   - `./scripts/start-codex.sh --desktop`
   - `./scripts/start-codex.sh --check`
7. Verify MCP setup in Codex using `codex mcp` (or `/mcp` in TUI) and confirm `datadoe` is active.
8. After successful setup, try an example prompt in the Agent:
   - `Show me all sellers and vendors`

## Example prompt library starter pack

To help you start faster with an AI Agent + DataDoe MCP workflow, this repo includes a small prompt library at:

- `.codex/prompts/EXAMPLES.md`

Use it as a starter pack:

1. Open `.codex/prompts/EXAMPLES.md`.
2. Copy a prompt block and adjust placeholders (for example `{{seller_name}}`) to your account context.
3. Run the prompt in Codex Desktop app or Codex CLI chat with DataDoe MCP enabled.
4. Save your own high-performing prompts in the same file to build a reusable internal playbook.

## Run Codex from Dedicated Launcher

This repository includes a dedicated launcher script:

> [!WARNING]
> `scripts/start-codex.sh` is the protected launcher for this repository.
> Do not edit, replace, or "quick fix" it unless you are intentionally changing launcher behavior.

```bash
./scripts/start-codex.sh
```

The launcher loads `.env`, exports `DATADOE_MCP_KEY` into the current process, and then starts Codex CLI or Codex Desktop from the repository root.

Short manual:

```bash
# Interactive menu (recommended)
./scripts/start-codex.sh

# Direct launch Codex CLI
./scripts/start-codex.sh --cli

# Direct launch Codex Desktop
./scripts/start-codex.sh --desktop

# Validate env loading + launcher availability only
./scripts/start-codex.sh --check

# Help
./scripts/start-codex.sh --help
```

If needed, make it executable once:

```bash
chmod +x ./scripts/start-codex.sh
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
> Never commit real keys to git.
> If a key is exposed, rotate it immediately.

## How to get help

- Email: [contact@datadoe.com](mailto:contact@datadoe.com)
- Codex Docs: [openai/codex](https://developers.openai.com/codex)
- Codex CLI: [openai/codex/cli](https://developers.openai.com/codex/cli)
