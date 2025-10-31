{
  config,
  lib,
  pkgs,
  ...
}: let
  sassFile = import ./config/style.nix config pkgs;
  compiledSassFile =
    pkgs.runCommand "style_swaync" {nativeBuildInputs = with pkgs; [dart-sass jq];}
    ''
      #!/usr/bin/env bash
      mkdir -p $out
      cat > "$out/styleSwaync.scss" <<'EOF'
      ${sassFile}
      EOF
      sass "$out/styleSwaync.scss" "$out/.config/swaync/style.css"
    '';
in {
  options.hm.swaync = {
    enable = lib.mkEnableOption "Enable swaync support";
  };

  config = lib.mkIf config.hm.swaync.enable {
    home.packages = [compiledSassFile];
    xdg.configFile."swaync/style.css" = {
      source = "${compiledSassFile}/.config/swaync/style.css";
      onChange = '''';
    };

    services.swaync = {
      enable = true;
      # style = builtins.readFile ./config/style.css;
    };
  };
}
