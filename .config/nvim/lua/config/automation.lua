local grp = vim.api.nvim_create_augroup("auto_reload", { clear = true })

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
	group = grp,
	pattern = "*",
	callback = function()
		if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
			vim.cmd("checktime")
		end
	end,
})

vim.api.nvim_create_autocmd("FileChangedShellPost", {
	group = grp,
	pattern = "*",
	callback = function()
		vim.notify("Buffer reloaded from disk", vim.log.levels.INFO)
	end,
})
