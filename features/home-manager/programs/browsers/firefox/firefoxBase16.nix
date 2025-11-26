{
  config,
  lib,
  pkgs,
  ...
}: let
  repo = builtins.fetchGit {
    url = "https://github.com/BBFifield/firefox-native-base16.git";
    rev = "27787984cfa5897d76d0b7437366c2e4a33a0f7f";
    ref = "master";
  };

  launcherScript = pkgs.writeShellScript "firefox-native-base16-launcher" ''
    trap 'kill -SIGTERM $native_pid' SIGTERM
    ${pkgs.firefox-base16}/bin/firefox-native-base16 &
    native_pid=$!
    wait $native_pid
  '';
in {
  config = let
    manifestFile = "${config.home.homeDirectory}/.mozilla/native-messaging-hosts/firefox_native_base16.json";
  in
    lib.mkIf (config.hm.tintednix.targets.firefox.enable)
    {
      home.activation.firefoxBase16 = lib.hm.dag.entryAfter ["writeBoundary"] ''
        if ! test -f ${manifestFile}; then
          mkdir -p ${config.home.homeDirectory}/.mozilla/native-messaging-hosts
          jq ".path = \"${launcherScript}\"" "${repo}/manifest.json" >"${manifestFile}"
        else
          current_path=$(jq ".path" ${manifestFile})
          if [ $current_path != "${launcherScript}" ]; then
            jq ".path = \"${launcherScript}\"" ${repo}/manifest.json >"${manifestFile}"
          fi
        fi
      '';
    };
}
