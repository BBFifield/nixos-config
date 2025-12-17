{config, ...}: {
  # SSH stuff
  config = {
    home.file = {
      ".ssh/id_ed25519.pub".source = ../../../../../users/${config.home.username}/ssh/id_ed25519.pub;
      ".ssh/known_hosts".source = ../../../../../users/${config.home.username}/ssh/known_hosts;
    };

    # Hmmm, where should the age key be placed if this is the first time running the script
    sops = {
      # This is using an age key that is expected to already be in the filesystem
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      # This is the actual specification of the secrets.
      secrets = {
        sshSecret = {
          sopsFile = ../../../../../secrets/.ssh/id_ed25519.sops;
          path = "${config.home.homeDirectory}/.ssh/id_ed25519";
          key = "data";
        };
      };
    };
  };
}
