{config, ...}: {
  programs.git = {
    settings = {
      core = {
        editor = "nvim";
      };
      color.ui = "auto";
      init.defaultBranch = "master";
    };
  };
}
