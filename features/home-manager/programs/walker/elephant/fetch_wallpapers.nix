{pkgs, ...}: let
  notify = "${pkgs.libnotify}/bin/notify-send";
  convert = "${pkgs.imagemagick}/bin/convert";
in
  pkgs.writeTextFile {
    name = "fetch_wallpapers.lua";
    text = ''
      function GetEntries()
        local entries = {}
        local home = os.getenv("HOME") or ""
        local wallpaper_dir_symlink = home .. "/Pictures/wallpapers"
        local cache_dir = home .. "/.cache/walker-wallpapers"
        local thumbnail_size = "180x180"

        local resolve_handle = io.popen("readlink -f " .. string.format("%q", wallpaper_dir_symlink))
        local wallpaper_dir = nil
        if resolve_handle then
          wallpaper_dir = resolve_handle:read("*l")
          resolve_handle:close()
        end
        if not wallpaper_dir or wallpaper_dir == "" then
          wallpaper_dir = wallpaper_dir_symlink
        end

        os.execute("mkdir -p " .. string.format("%q", cache_dir) .. " 2>/dev/null")

        local find_cmd = "find " .. string.format("%q", wallpaper_dir)
          .. " -type f \\( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.webp' \\) -print0"
        local handle = io.popen(find_cmd, "r")

        local needs_caching = false
        local cached_count = 0

        if handle then
          local chunk = handle:read("*a")
          handle:close()
          if chunk and #chunk > 0 then
            for filename in string.gmatch(chunk, "([^%z]+)%z") do
              local basename = filename:match("([^/]+)$")
              if basename then
                local cache_name = basename:gsub("%.", "_") .. ".png"
                local cache_file = cache_dir .. "/" .. cache_name
                local f = io.open(cache_file, "rb")
                local icon_to_use = cache_file
                if not f then
                  if not needs_caching then
                    needs_caching = true
                    os.execute(${notify} .. " 'Wallpapers' 'Generating thumbnails - menu will refresh automatically' -t 8000")
                  end
                  local convert_cmd = ${convert} .. " " .. string.format("%q", filename)
                    .. " -resize " .. thumbnail_size .. "^ -gravity center -extent " .. thumbnail_size
                    .. " " .. string.format("%q", cache_file) .. " 2>/dev/null"
                  os.execute(convert_cmd)
                  cached_count = cached_count + 1
                  icon_to_use = filename
                else
                  f:close()
                end

                table.insert(entries, {
                  Text = basename,
                  Value = filename,
                  Icon = icon_to_use,
                })
              end
            end
          end
        end

        if needs_caching then
          os.execute(${notify} .. " 'Wallpapers' 'Generated " .. cached_count .. " thumbnails' -t 6000")
        end

        return entries
      end
    '';
  }
