/**
 * Neovim Prompt Editor Extension
 *
 * Provides neovim editing capabilities for Pi prompts.
 * Usage:
 * - Command: /nvim - Open neovim editor with current prompt content
 */

import type { ExtensionAPI } from "@mariozechner/pi-coding-agent";
import { tmpdir } from "os";
import { join } from "path";
import { writeFileSync, readFileSync, unlinkSync } from "fs";

export default function (pi: ExtensionAPI) {
	// Register a command to open neovim editor
	pi.registerCommand("nvim", {
		description: "Open neovim editor for prompt composition",
		handler: async (_args, ctx) => {
			if (!ctx.hasUI) {
				return "Neovim editor only available in interactive mode";
			}
			
			return await openNeovimEditor(ctx);
		},
	});
	
	// Helper function to open neovim editor
	async function openNeovimEditor(ctx: any) {
		// Create a temporary file
		const tempFilePath = join(tmpdir(), `pi-nvim-editor-${Date.now()}.txt`);
		
		try {
			// Get current editor content if any
			const currentContent = await ctx.ui.getEditorText();
			
			// Write current content to temp file
			writeFileSync(tempFilePath, currentContent, "utf-8");
			
			// Notify user that neovim is opening
			ctx.ui.notify("Opening neovim editor...", "info");
			
			// Open neovim with the temp file using bash tool
			const toolResult = await ctx.runTool("bash", {
				command: `nvim "${tempFilePath}"`
			});
			
			if (toolResult && toolResult.content) {
				// Check if neovim exited successfully (exit code 0)
				const bashResult = toolResult.content.find((item: any) => item.type === "bash_result");
				const exitCode = bashResult ? bashResult.result?.code : 0;
				
				if (exitCode === 0) {
					// Read the content back from the file
					const editedContent = readFileSync(tempFilePath, "utf-8");
					
					// Set the editor text to the edited content (without submitting)
					await ctx.ui.setEditorText(editedContent);
					
					ctx.ui.notify("Content updated from Neovim editor", "success");
					return "Content updated from Neovim editor";
				} else {
					ctx.ui.notify("Neovim editor exited with error", "warning");
					return "Neovim editor exited with error";
				}
			} else {
				// If we can't get the result directly, try to read the file anyway
				// This might happen in some environments
				try {
					const editedContent = readFileSync(tempFilePath, "utf-8");
					await ctx.ui.setEditorText(editedContent);
					ctx.ui.notify("Content updated from Neovim editor", "success");
					return "Content updated from Neovim editor";
				} catch (readError) {
					ctx.ui.notify("Neovim editor completed but couldn't read content", "warning");
					return "Neovim editor completed but couldn't read content";
				}
			}
		} catch (error) {
			const errorMsg = `Error using Neovim editor: ${error instanceof Error ? error.message : String(error)}`;
			ctx.ui.notify(errorMsg, "error");
			return errorMsg;
		} finally {
			// Clean up temp file
			try {
				unlinkSync(tempFilePath);
			} catch (err) {
				// Ignore cleanup errors
			}
		}
	}
}