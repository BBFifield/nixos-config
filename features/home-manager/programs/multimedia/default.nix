{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./mpv
    ./tauon
    ./fragments
    ./satty
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
      loupe
    ];

    xdg.enable = true;
    xdg.mime.enable = true;
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = ["yazi.desktop"];
        "image/gif" = ["org.gnome.Loupe.desktop"];
        "image/jpeg" = ["org.gnome.Loupe.desktop"];
        "image/pjpeg" = ["org.gnome.Loupe.desktop"];
        "image/png" = ["org.gnome.Loupe.desktop"];
        "image/vnd.adobe.photoshop" = ["gimp.desktop"];
        "image/webp" = ["firefox.desktop"];
        "image/x-adobe-dng" = ["gimp.desktop"];
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
