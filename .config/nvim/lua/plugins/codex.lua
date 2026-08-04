return {
	"dukjjang/codex-cli.nvim",
	config = function()
		require("codex_cli").setup({
			tmux = {
				command = "codex", -- match process name for pane detection
			},
			split = {
				command = "codex", -- command used to launch Codex CLI
				direction = "right", -- "right" or "below"
				size = 0.4,
			},
			overlay = {
				enabled = false,
			},
			keymaps = {
				enabled = true,
				ask = "<leader>pa",
				visual = "<leader>pa",
				toggle = "<leader>at",
			},
			command = "CodexSend",
			command_ask = "CodexAsk",
			command_toggle = "CodexToggle",
		})
	end,
}
