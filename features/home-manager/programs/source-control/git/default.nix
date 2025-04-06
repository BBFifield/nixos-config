{config, ...}: {
  programs.git = {
    extraConfig = {
      core = {
        editor = "nvim";
      };
      color.ui = "auto";
      init.defaultBranch = "master";
    };
  };
}
