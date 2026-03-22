/**
 * Confirm Install Extension
 *
 * Prompts for confirmation before running potentially destructive
 * package manager commands (npm, npx, yarn, pip, apt, brew, asdf, etc.).
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";

export default function (pi: ExtensionAPI) {
	// Destructive package manager command patterns
	const destructivePatterns = [
		// npm patterns
		{ pattern: /\bnpm\s+(install|i)\s+.*(-g|--global)\b/i, description: "npm global install" },
		{ pattern: /\bnpm\s+(install|i)\s+.*(--force|-f)\b/i, description: "npm forced install" },
		{ pattern: /\bnpm\s+(install|i)\s+.*(@latest)\b/i, description: "npm install @latest" },
		{ pattern: /\bnpm\s+(uninstall|remove|rm)\b/i, description: "npm uninstall package" },
		{ pattern: /\bnpm\s+(update|upgrade|up)\b/i, description: "npm update packages" },
		{ pattern: /\bnpm\s+(ci|link|publish)\b/i, description: "npm special command" },

		// npx patterns (potentially destructive as it can execute remote packages)
		{ pattern: /\bnpx\s+/i, description: "npx command execution" },

		// yarn patterns
		{ pattern: /\byarn\s+add\s+.*(-g|--global)\b/i, description: "yarn global add" },
		{ pattern: /\byarn\s+(remove|unlink)\b/i, description: "yarn remove package" },
		{ pattern: /\byarn\s+(install|upgrade|publish)\b/i, description: "yarn special command" },

		// pnpm patterns
		{ pattern: /\bpnpm\s+add\s+.*(-g|--global)\b/i, description: "pnpm global add" },
		{ pattern: /\bpnpm\s+(remove|rm|unlink)\b/i, description: "pnpm remove package" },
		{ pattern: /\bpnpm\s+(install|update|publish)\b/i, description: "pnpm special command" },

		// pip patterns
		{ pattern: /\bpip\s+(install|uninstall)\b/i, description: "pip package management" },

		// apt/apt-get patterns
		{ pattern: /\bapt(-get)?\s+(install|remove|purge|update|upgrade)\b/i, description: "system package management" },

		// brew patterns
		{ pattern: /\bbrew\s+(install|uninstall|upgrade)\b/i, description: "Homebrew package management" },

		// asdf patterns
		{ pattern: /\basdf\s+(install|uninstall|plugin-add|plugin-remove)\b/i, description: "asdf version management" },

		// pacman patterns (more specific)
		{ pattern: /\bpacman\s+-S\S*\s+/i, description: "pacman install package" },
		{ pattern: /\bpacman\s+-R\S*\s+/i, description: "pacman remove package" },
		{ pattern: /\bpacman\s+-Syu\b/i, description: "pacman system upgrade" },
	];

	// Handler for LLM-initiated bash commands
	pi.on("tool_call", async (event, ctx) => {
		if (event.toolName !== "bash") return undefined;

		const command = event.input.command as string;
		const matchedPattern = destructivePatterns.find(({ pattern }) => pattern.test(command));

		if (matchedPattern) {
			if (!ctx.hasUI) {
				// In non-interactive mode, block by default
				return { 
					block: true, 
					reason: `Potentially destructive ${matchedPattern.description} command blocked (no UI for confirmation)` 
				};
			}

			const choice = await ctx.ui.select(
				`⚠️ Potentially Destructive Command Detected\n\nCommand: ${command}\nType: ${matchedPattern.description}\n\nAllow execution?`, 
				[
					"Yes, execute command",
					"No, block command",
				]
			);

			if (choice !== "Yes, execute command") {
				ctx.ui.notify(`Blocked ${matchedPattern.description}: ${command}`, "info");
				return { block: true, reason: "Blocked by user" };
			}
			
			ctx.ui.notify(`Confirmed ${matchedPattern.description}: ${command}`, "warning");
		}

		return undefined;
	});

	// Handler for user-initiated bash commands (! or !! prefix)
	pi.on("user_bash", async (event, ctx) => {
		const command = event.command;
		const matchedPattern = destructivePatterns.find(({ pattern }) => pattern.test(command));

		if (matchedPattern) {
			if (!ctx.hasUI) {
				// In non-interactive mode, allow by default (user explicitly ran the command)
				// but notify about potential risks
				ctx.ui.notify(
					`Executing potentially destructive command: ${command} (${matchedPattern.description})`,
					"warning",
				);
				return undefined;
			}

			const choice = await ctx.ui.select(
				`⚠️ Potentially Destructive Command Detected\n\nCommand: ${command}\nType: ${matchedPattern.description}\n\nAllow execution?`, 
				[
					"Yes, execute command",
					"No, cancel command",
				]
			);

			if (choice !== "Yes, execute command") {
				ctx.ui.notify(`Cancelled ${matchedPattern.description}: ${command}`, "info");
				// Note: For user_bash, we can't directly block the execution in the event handler
				// The best we can do is notify the user
				return undefined;
			}
			
			ctx.ui.notify(`Confirmed ${matchedPattern.description}: ${command}`, "warning");
		}

		return undefined;
	});
}