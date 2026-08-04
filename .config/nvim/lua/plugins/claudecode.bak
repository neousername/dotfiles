return {
	"coder/claudecode.nvim",
	dependencies = { "folke/snacks.nvim" },
	opts = {
		terminal_cmd = "~/.local/bin/claude",
		terminal = {
			provider = "none", -- no UI actions; server + tools remain available
		},
	},
	config = true,
	-- `cmd` lets lazy.nvim create command stubs that load the plugin on first use,
	-- so `:ClaudeCode` and friends work on a fresh start. Without it, a keys-only
	-- spec defers loading until a <leader>a* mapping is pressed and the commands
	-- would not exist yet.
	cmd = {
		"ClaudeCode",
		"ClaudeCodeFocus",
		"ClaudeCodeSelectModel",
		"ClaudeCodeAdd",
		"ClaudeCodeSend",
		"ClaudeCodeTreeAdd",
		"ClaudeCodeStatus",
		"ClaudeCodeStart",
		"ClaudeCodeStop",
		"ClaudeCodeOpen",
		"ClaudeCodeClose",
		"ClaudeCodeDiffAccept",
		"ClaudeCodeDiffDeny",
		"ClaudeCodeCloseAllDiffs",
	},
	keys = {
		{ "<leader>pa", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
		{ "<leader>pa", "V<cmd>ClaudeCodeSend<cr>", mode = "n", desc = "Send line to Claude" },
	},
}
