{lib, ...}: {
  imports = [./cursors ./fonts ./gtk ./icons ./qt];

  options.hm.theme = {
    live = lib.mkOption {
      type = (import ../submodules {inherit lib;}).live; #Only applies to gtk theme for now
    };
  };
}
