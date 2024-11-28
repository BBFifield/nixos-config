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

  launcherScript = pkgs.writeScript "firefox-native-base16-launcher" ''
    #!/run/current-system/sw/bin/bash

    trap 'kill -SIGTERM $native_pid' SIGTERM
    ${pkgs.firefox-base16}/bin/firefox-native-base16 &
    native_pid=$!
    wait $native_pid
  '';
in {
  config = lib.mkIf (config.tintednix.targets.firefox.enable) (
    lib.mkMerge [
      {
        home.activation.firefox_base16 = lib.hm.dag.entryAfter ["writeBoundary"] ''
          if ! test -f "${config.home.homeDirectory}/.mozilla/native-messaging-hosts/firefox_native_base16.json"; then
            mkdir -p ${config.home.homeDirectory}/.mozilla/native-messaging-hosts
            jq ".path = \"${launcherScript}\"" "${repo}/manifest.json" >"${config.home.homeDirectory}/.mozilla/native-messaging-hosts/firefox_native_base16.json"
          fi
        '';

        home.packages = with pkgs; [
          firefox-base16
        ];
      }
    ]
  );
}
