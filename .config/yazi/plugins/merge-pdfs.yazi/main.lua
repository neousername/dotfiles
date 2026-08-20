local get_selected = ya.sync(function()
	local urls = {}
	local cwd = tostring(cx.active.current.cwd)

	for _, url in pairs(cx.active.selected) do
		urls[#urls + 1] = tostring(url)
	end

	return urls, cwd
end)

return {
	entry = function()
		local urls, cwd = get_selected()
		local files = {}

		for _, path in ipairs(urls) do
			local cha = fs.cha(Url(path))

			if not path:lower():match("%.pdf$") or not cha or cha.is_dir then
				ya.notify({
					title = "Merge PDFs",
					content = "Select PDF files only",
					timeout = 5,
					level = "warn",
				})
				return
			end

			if not cha.btime then
				ya.notify({
					title = "Merge PDFs",
					content = "A selected PDF has no creation date",
					timeout = 5,
					level = "error",
				})
				return
			end

			files[#files + 1] = { path = path, btime = cha.btime }
		end

		if #files < 2 then
			ya.notify({
				title = "Merge PDFs",
				content = "Select at least two PDF files",
				timeout = 5,
				level = "warn",
			})
			return
		end

		table.sort(files, function(a, b)
			return a.btime == b.btime and a.path < b.path or a.btime < b.btime
		end)

		local args = {}

		for _, file in ipairs(files) do
			args[#args + 1] = file.path
		end

		args[#args + 1] = ".merged.pdf.tmp"

		local status, err = Command("pdfunite"):cwd(cwd):arg(args):status()

		if err or not status.success then
			ya.notify({
				title = "Merge PDFs",
				content = err and tostring(err) or "pdfunite failed",
				timeout = 8,
				level = "error",
			})
			return
		end

		local ok, rename_err = fs.rename(Url(cwd):join(".merged.pdf.tmp"), Url(cwd):join("merged.pdf"))

		if not ok then
			ya.notify({
				title = "Merge PDFs",
				content = tostring(rename_err),
				timeout = 8,
				level = "error",
			})
			return
		end

		ya.notify({
			title = "Merge PDFs",
			content = "Created merged.pdf",
			timeout = 5,
		})
	end,
}
