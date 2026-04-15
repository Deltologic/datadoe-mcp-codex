# DataDoe MCP + Codex Example

This repository is a minimal example of using the DataDoe MCP server from Codex for Amazon-focused workflows.

## Table of contents

- [What you can do with this repo](#what-you-can-do-with-this-repo)
- [What this repo is](#what-this-repo-is)
- [How to start working with it](#how-to-start-working-with-it)
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

## How to start working with it

1. Clone the repository:
   ```bash
   git clone https://github.com/Deltologic/datadoe-mcp-codex
   cd datadoe-mcp-codex
   ```
2. Open `.codex/config.toml` and paste your real MCP key directly:
   - `url = "https://api.datadoe.com/mcp/v1"`
   - `http_headers = { datadoe-mcp-key = "your_real_key_here" }`
3. Run `codex mcp` (or `/mcp` in TUI) and verify `datadoe` is active.
4. Start Codex and ask an Amazon-related question.

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

We are working on a more secure way of passing the MCP key into the TOML file to avoid storing real secrets directly in `.codex/config.toml`.

## Tags

`DataDoe` `MCP` `Codex` `Amazon` `Amazon Seller` `AI Assistant` `LLM` `Prompting`
