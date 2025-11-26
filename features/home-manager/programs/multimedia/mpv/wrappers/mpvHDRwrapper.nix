{pkgs}:
pkgs.writeShellApplication {
  name = "mpv-hdr";
  runtimeInputs = with pkgs; [mediainfo];
  text = ''
    # mpv-hdr wrapper
    # Usage: mpv-hdr [mpv args and/or files...]
    # Detects HDR/DV via filename heuristics or optional ffprobe/mediainfo probe.
    # If HDR-like, export ENABLE_HDR_WSI and use --profile=HDR_Display.

    probe_file_for_hdr() {
      # $1 = path; returns 0 if looks HDR/DV; 1 otherwise
      p="$1"

      # 1) quick filename heuristics (case-insensitive)
      bn=$(basename "$p" | tr '[:upper:]' '[:lower:]')
      if printf '%s\n' "$bn" \
         | grep -E '(^|[^[:alnum:]])(hdr|dv|dovi|dolby[._-]?vision)([^[:alnum:]]|$)' >/dev/null; then
        return 0
      fi

      # 2) try ffprobe (fast) if available
      if command -v ffprobe >/dev/null 2>&1; then
        # look for color transfer or "Dolby Vision" in streams/tags
        if ffprobe -v error -select_streams v:0 -show_entries stream=color_transfer:stream_tags=variant -of default=noprint_wrappers=1:nokey=1 "$p" 2>/dev/null \
           | tr '[:upper:]' '[:lower:]' | grep -E '(^|[^[:alnum:]])(pq|smpte2084|dolby)([^[:alnum:]]|$)' >/dev/null 2>&1; then
          return 0
        fi
        # check for dv in format tags
        if ffprobe -v error -show_format -of default=noprint_wrappers=1:nokey=1 "$p" 2>/dev/null \
           | tr '[:upper:]' '[:lower:]' | grep -E '(^|[^[:alnum:]])(dolby vision|dv)([^[:alnum:]]|$)' >/dev/null 2>&1; then
          return 0
        fi
      fi

      # 3) try mediainfo if available (more verbose)
      if command -v mediainfo >/dev/null 2>&1; then
        if mediainfo --Output=JSON "$p" 2>/dev/null \
           | tr '[:upper:]' '[:lower:]' | grep -E '(^|[^[:alnum:]])(dolby vision|pq|hdr10)([^[:alnum:]]|$)' >/dev/null 2>&1; then
          return 0
        fi
      fi

      return 1
    }

    # Parse args: we want to extract file arguments but preserve other args.
    # We will collect file-like args to probe; rules:
    #  - tokens that do NOT start with - are treated as files/URLs
    #  - tokens after -- are all files
    files=()
    remaining_args=()
    after_dashdash=0

    for arg in "$@"; do
      if [ "$after_dashdash" -eq 1 ]; then
        files+=("$arg")
        remaining_args+=("$arg")
        continue
      fi
      case "$arg" in
        --) after_dashdash=1; remaining_args+=("$arg");;
        --*=*)  # long opt with value in same token
          remaining_args+=("$arg");;
        -*)     # option
          remaining_args+=("$arg");;
        *)      # positional; treat as file/url
          files+=("$arg")
          remaining_args+=("$arg");;
      esac
    done

    # If no explicit files found (e.g., invoked from DE with %U), try remaining args later.
    is_hdr=1  # default: not hdr (1 = false)
    for f in "''${files[@]}"; do
      # skip URIs that look like mpv special tokens (e.g., "mpv://")? keep simple
      if probe_file_for_hdr "$f"; then
        is_hdr=0
        break
      fi
    done

    # If no files found at all, we still want to accept stdin/URL launches: default to non-HDR
    if [ "''${#files[@]}" -eq 0 ]; then
      is_hdr=1
    fi

    # Launch mpv with correct env/profile
    if [ "$is_hdr" -eq 0 ]; then
      export ENABLE_HDR_WSI=1
      exec mpv --profile=HDR_Display "$@"
    else
      exec mpv "$@"
    fi
  '';
}
