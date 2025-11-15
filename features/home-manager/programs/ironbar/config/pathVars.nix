config: pkgs:
pkgs.writeTextFile {
  name = "_path-vars.scss";
  text = ''
    $profile-pic: "/var/lib/AccountsService/icons/${config.home.username}.face.icon";
  '';
}
