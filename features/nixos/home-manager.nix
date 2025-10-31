{
  self,
  inputs,
  lib,
  ...
}:
with inputs; {
  options.nixos.hm = {
  };

  config = {
    # home-manager.lib = home-manager.lib.extend (f: p: import ../../lib);
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    home-manager.backupFileExtension = "backup";

    home-manager.users = {
      brandon = import ../../users/brandon;
    };
    #lib.pathToAttrs "${self}/users" (full_path: _: import full_path);

    # These modules are imported into all home-manager configs
    home-manager.sharedModules = [
      plasma-manager.homeModules.plasma-manager
      sops-nix.homeManagerModules.sops
      walker.homeManagerModules.default
      ironbar.homeManagerModules.default
      neovim-config.homeManagerModules.default
      tintednix.homeManagerModules.default
    ];
  };
}
