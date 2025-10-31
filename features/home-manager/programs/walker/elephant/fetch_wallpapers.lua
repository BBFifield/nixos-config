function GetEntries()
	local entries = {}
	local home = os.getenv("HOME") or ""
	local wallpaper_dir_symlink = home .. "/Pictures/wallpapers"
	local cache_dir = home .. "/.cache/walker-wallpapers"
	local thumbnail_size = "180x180"

	local resolve_handle = io.popen("readlink -f '" .. wallpaper_dir_symlink .. "'")
	local wallpaper_dir = nil
	if resolve_handle then
		wallpaper_dir = resolve_handle:read("*l")
		resolve_handle:close()
	end

	if not wallpaper_dir or wallpaper_dir == "" then
		wallpaper_dir = wallpaper_dir_symlink
	end

	os.execute("mkdir -p '" .. cache_dir .. "' 2>/dev/null")

	local needs_caching = false
	local cached_count = 0

	local cmd = "for ext in jpg jpeg png gif bmp webp JPG JPEG PNG GIF BMP WEBP; do ls -1 '"
		.. wallpaper_dir
		.. "'/*.$ext 2>/dev/null; done"
	local handle = io.popen(cmd)

	if handle then
		for line in handle:lines() do
			local filename = line:match("([^/]+)$")

			if filename then
				local cache_name = filename:gsub("%.", "_") .. ".png"
				local cache_file = cache_dir .. "/" .. cache_name

				local f = io.open(cache_file, "r")
				local icon_to_use = cache_file
				if not f then
					if not needs_caching then
						needs_caching = true
						os.execute(
							"notify-send 'Wallpapers' 'Generating thumbnails - menu will refresh automatically' -t 8000"
						)
					end
					os.execute(
						"convert '"
							.. line
							.. "' -resize "
							.. thumbnail_size
							.. "^ -gravity center -extent "
							.. thumbnail_size
							.. " '"
							.. cache_file
							.. "' 2>/dev/null"
					)
					cached_count = cached_count + 1
					icon_to_use = line
				else
					f:close()
				end

				table.insert(entries, {
					Text = filename,
					Value = line,
					Icon = icon_to_use,
				})
			end
		end
		handle:close()
	end

	if needs_caching then
		os.execute("notify-send 'Wallpapers' 'Generated " .. cached_count .. " thumbnails' -t 6000")
	end

	return entries
end
