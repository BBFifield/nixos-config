{pkgs}:
pkgs.writeShellApplication {
  name = "umpv-from-clipboard";
  runtimeInputs = with pkgs; [yt-dlp libnotify];
  text = ''
    # Read clipboard, preserve newlines
    read_clipboard() {
      if command -v wl-paste >/dev/null 2>&1; then
        wl-paste --no-newline 2>/dev/null || true
      else
        printf ""
      fi
    }

    # Extract first http/https url (conservative)
    extract_url() {
      printf '%s' "$1" \
        | grep -oE "https?://[^[:space:]\"'<>]+" \
        | head -n1 || true
    }

    # Extract domain from URL (lowercased)
    get_domain() {
      # strip scheme
      url="$1"
      # remove scheme://
      url="''${url#*://}"
      # cut at first / or : (port)
      domain="$(printf '%s' "$url" | sed -E 's#/.*##; s/:.*//')"
      # lower
      printf '%s' "$(printf '%s' "$domain" | tr '[:upper:]' '[:lower:]')"
    }

    # Whitelist domains for direct open (no yt-dlp check)
    is_whitelisted() {
      domain="$1"
      case "$domain" in
        youtube.com|www.youtube.com|youtu.be|m.youtube.com) return 0 ;;
        twitch.tv|www.twitch.tv) return 0 ;;
        tiktok.com|www.tiktok.com|vm.tiktok.com) return 0 ;;
        twitter.com|www.twitter.com|x.com|www.x.com) return 0 ;;
        reddit.com|www.reddit.com|v.redd.it) return 0 ;;
        *) return 1 ;;
      esac
    }

    # main
    clip="$(read_clipboard)"
    if [ $# -ge 1 ]; then
      candidate="$1"
    else
      candidate="$(extract_url "$clip")"
    fi

    if [ -z "$candidate" ]; then
      printf '%s\n' "No http/https URL found in clipboard or args." >&2
      notify-send -a "mpv" -e -t 3000 "" "No http/https URL found in clipboard"
      exit 2
    fi

    domain="$(get_domain "$candidate")"

    if is_whitelisted "$domain"; then
      printf '%s\n' "Whitelisted domain ($domain) — opening in umpv: $candidate"
      umpv "$candidate" &
      exit 0
    fi

    # Non-whitelisted: verify with yt-dlp if available
    notify-send -a "mpv" -e -t 3000 "Please wait: Verifying this is a compatible video link"
    if ! command -v yt-dlp >/dev/null 2>&1; then
      printf '%s\n' "yt-dlp not found; refusing to open non-whitelisted URL: $candidate" >&2
      exit 3
    fi

    if yt-dlp --no-warnings --quiet --get-title -- "$candidate" >/dev/null 2>&1; then
      printf '%s\n' "yt-dlp supports URL — opening in umpv: $candidate"
      umpv "$candidate" &
      exit 0
    else
      printf '%s\n' "URL not supported by yt-dlp: $candidate" >&2
      notify-send -a "mpv" -e -t 3000 "Unsupported URL" "$candidate"
      exit 4
    fi
  '';
}
