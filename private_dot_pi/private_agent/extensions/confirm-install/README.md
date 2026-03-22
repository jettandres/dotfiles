# Confirm Install Extension

This extension prompts for confirmation before running potentially destructive package manager commands.

## Features

The extension intercepts and confirms execution of commands from these package managers:

- **npm**: `npm install [-g|--global]`, `npm i [--force|-f]`, `npm install @latest`, `npm uninstall`, `npm update`, `npm ci`, `npm link`, `npm publish`
- **npx**: `npx [command]` (any npx command)
- **yarn**: `yarn add [-g|--global]`, `yarn remove`, `yarn install`, `yarn upgrade`, `yarn publish`
- **pnpm**: `pnpm add [-g|--global]`, `pnpm remove`, `pnpm install`, `pnpm update`, `pnpm publish`
- **pip**: `pip install`, `pip uninstall`
- **apt/apt-get**: `apt install`, `apt remove`, `apt purge`, `apt update`, `apt upgrade`, `apt-get install`, etc.
- **brew**: `brew install`, `brew uninstall`, `brew upgrade`
- **asdf**: `asdf install`, `asdf uninstall`, `asdf plugin-add`, `asdf plugin-remove`
- **pacman**: `pacman -S`, `pawn -R`, `pacman -Syu`

## How It Works

The extension listens for two types of events:

1. **`tool_call`** - When the AI tries to execute a bash command through the bash tool
2. **`user_bash`** - When the user executes a command with `!` or `!!` prefix

When a potentially destructive command is detected, the extension will:
- Show a confirmation dialog in interactive mode
- Block the command by default in non-interactive modes
- Notify the user about potentially destructive commands in all modes

## Installation

You can install this extension in several ways:

### Method 1: Direct Directory Placement
Clone or copy the `confirm-install` directory to your pi extensions directory:

- Global: `~/.pi/agent/extensions/confirm-install/`
- Project-local: `.pi/extensions/confirm-install/`

### Method 2: Using pi package install
```bash
pi install /path/to/confirm-install
```

The extension will be automatically loaded on pi startup.

## Configuration

Currently, there is no configuration available. The extension uses predefined patterns to detect destructive commands.