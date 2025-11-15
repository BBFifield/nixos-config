{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./mpv
    ./tauon
    ./fragments
  ];
  config = {
    home.packages = with pkgs; [
      gnome-music
      euphonica
      pwvucontrol
      easytag
      gimp3
      amberol
      recordbox
    ];

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["yazi.desktop"];
      };
    };

    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
      settings = {
        program_options = {
          file_manager = "${config.hm.terminal.default} -T Yazi --class yazi -e yazi";
          terminal = "${config.hm.terminal.default} --working-directory";
          menu_checkbox_workaround = false;
          menu_update_workaround = false;
        };
      };
    };
  };
}
