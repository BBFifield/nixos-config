{...}: {
  programs.btop = {
    enable = true;
    settings = {
      color_theme = "base16";
      theme_background = false;
      vim_keys = true;
    };
  };
  programs.htop.enable = true;
}
