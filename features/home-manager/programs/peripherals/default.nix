{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [bluetui];

  xdg.configFile."bluetui/config.toml".source = (pkgs.formats.toml {}).generate "bluetui-config.toml" {
    # Possible values: "Legacy", "Start", "End", "Center", "SpaceAround", "SpaceBetween"
    layout = "Start";

    # Window width
    # Possible values: "auto" or a positive integer
    width = "auto";

    toggle_scanning = "s";
    esc_quit = true; # Set to true to enable Esc key to quit the app

    adapter = {
      toggle_pairing = "p";
      toggle_power = "o";
      toggle_discovery = "d";
    };
    paired_device = {
      unpair = "u";
      toggle_trust = "t";
      rename = "e";
    };
  };
}
