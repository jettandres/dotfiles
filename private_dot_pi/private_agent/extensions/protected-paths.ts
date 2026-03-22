/**
 * Protected Paths Extension
 *
 * Blocks read operations on:
 * - Files listed in .gitignore
 * - The .git directory and its contents
 * - node_modules directory in the current working directory (except when path contains .asdf)
 * Allows write and edit operations even on protected files.
 * Useful for preventing accidental reading of ignored files or local dependencies while still allowing modifications.
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { existsSync, readFileSync } from "fs";
import { join } from "path";

export default function (pi: ExtensionAPI) {
	// Exception path that can access node_modules
	const exceptionPath = ".asdf";
	
	pi.on("tool_call", async (event, ctx) => {
		// Only intercept read operations
		if (event.toolName !== "read") {
			return undefined;
		}

		const path = event.input.path as string;
		
		// Use ctx.cwd for the current working directory
		const localNodeModules = join(ctx.cwd, "node_modules/");
		
		// Check if path is in .git directory
		const isInGitDirectory = path.startsWith(".git/") || path.includes("/.git/");
		
		// Check if path is in local node_modules directory
		const isInLocalNodeModules = path.startsWith(localNodeModules) || path === "node_modules/" || path.startsWith("node_modules/");
		
		// Allow read from node_modules if it's within .asdf directory
		const hasException = path.includes(exceptionPath);
		const shouldBlockNodeModules = isInLocalNodeModules && !hasException;
		
		// Check gitignore patterns
		let isGitIgnored = false;
		if (!isInGitDirectory && !isInLocalNodeModules) {
			// Load gitignore patterns relative to ctx.cwd
			const gitIgnorePath = join(ctx.cwd, ".gitignore");
			if (existsSync(gitIgnorePath)) {
				try {
					const content = readFileSync(gitIgnorePath, "utf-8");
					const gitIgnorePatterns = content
						.split("\n")
						.map(line => line.trim())
						.filter(line => line && !line.startsWith("#"));
					
					isGitIgnored = gitIgnorePatterns.some(pattern => {
						// Simple pattern matching (doesn't handle all gitignore syntax)
						if (pattern.startsWith("/")) {
							// Absolute path pattern
							return path.startsWith(pattern.substring(1));
						} else if (pattern.includes("/")) {
							// Path pattern
							return path.includes(pattern);
						} else {
							// File/directory name pattern
							return path.includes(pattern) || path.includes(join("/", pattern));
						}
					});
				} catch (error) {
					console.warn("Failed to read .gitignore:", error);
				}
			}
		}

		// Block if:
		// 1. It's in .git directory, OR
		// 2. It's in local node_modules and NOT in .asdf directory, OR
		// 3. It's gitignored
		const shouldBlock = isInGitDirectory || shouldBlockNodeModules || isGitIgnored;

		if (shouldBlock) {
			let protectionType = "protected path";
			if (isInGitDirectory) {
				protectionType = ".git directory";
			} else if (isInLocalNodeModules) {
				protectionType = "local node_modules directory";
			} else if (isGitIgnored) {
				protectionType = "gitignored path";
			}
			
			if (ctx.hasUI) {
				ctx.ui.notify(`Blocked read operation on ${protectionType}: ${path}`, "warning");
			}
			return { block: true, reason: `Path "${path}" is in ${protectionType}` };
		}

		return undefined;
	});
}
