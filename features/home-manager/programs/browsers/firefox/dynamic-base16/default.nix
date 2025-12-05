{
  config,
  lib,
  pkgs,
  ...
}: let
  repo = builtins.fetchGit {
    url = "https://github.com/GnRlLeclerc/firefox-native-base16.git";
    rev = "6f2d7e4142975f10234bd43d6870c0e85d0650ac";
    ref = "master";
  };

  package = pkgs.firefox-base16.overrideAttrs (old: {
    patchPhase = ''
      for p in ${./firefox-native-base16.patch}; do
        patch -p1 < $p
      done
    '';
  });

  launcherScript = pkgs.writeShellScript "firefox-native-base16-launcher" ''
    trap 'kill -SIGTERM $native_pid' SIGTERM
    ${package}/bin/firefox-native-base16 &
    native_pid=$!
    wait $native_pid
  '';
in {
  config = let
    manifestFile = "${config.home.homeDirectory}/.mozilla/native-messaging-hosts/firefox_native_base16.json";
  in
    lib.mkIf (config.hm.tintednix.targets.firefox-dynamic.enable)
    {
      home.file.".mozilla/firefox/default/extensions/dynamic_base16@bbfifield.org.xpi".source = ./firefox-dynamic-base16.xpi;
      home.activation.firefoxBase16 = lib.hm.dag.entryAfter ["writeBoundary"] ''
        # desired values
        desired_path="${launcherScript}"
        desired_ext="dynamic_base16@bbfifield.org"

        if ! test -f ${manifestFile}; then
          jq --arg p "$desired_path" --arg a "$desired_ext" \
            '.path = $p | .allowed_extensions = [$a]' "${repo}/manifest.json" >"${manifestFile}"
        else
          current_path=$(jq -r '.path' "${manifestFile}")
          current_allowed=$(jq -r '.allowed_extensions[0]' "${manifestFile}")

          if [ "$current_path" != "$desired_path" ] || [ "$current_allowed" != "$desired_ext" ]; then
            jq --arg p "$desired_path" --arg a "$desired_ext" \
              '.path = $p | .allowed_extensions = [$a]' "${repo}/manifest.json" >"${manifestFile}"
          fi
        fi
      '';
    };
}
