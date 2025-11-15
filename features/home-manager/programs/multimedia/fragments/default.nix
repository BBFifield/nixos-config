{
  pkgs,
  config,
  ...
}: {
  config = {
    home.packages = with pkgs; [
      fragments
    ];

    xdg.configFile."fragments/settings.json".source = ./settings.json;
  };
}
