{
  stdenvNoCC,
  fetchurl,
  unzip,
  fontconfig,
  lib,
}: {
  ds-digital = stdenvNoCC.mkDerivation rec {
    pname = "ds-digital";
    version = "1.0";

    src = fetchurl {
      url = "https://dl.dafont.com/dl/?f=ds_digital";
      sha256 = "sha256-7goCaBVjvUCg/QdweEuC8w8zGr9boi1ga73UyTqF3e8=";
    };

    nativeBuildInputs = [unzip fontconfig];

    # Manually unzip the archive into the build directory
    unpackPhase = ''
      unzip -q ${src}
    '';

    # Skip all other build phases
    patchPhase = "true";
    configurePhase = "true";
    buildPhase = "true";
    checkPhase = "true";
    dontFixup = true;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype

      # The ZIP places all .TTF files at the top level
      for f in *.[Tt][Tt][Ff]; do
        install -Dm644 "$f" "$out/share/fonts/truetype/$f"
      done
    '';

    meta = with lib; {
      description = "DS-Digital segmented LCD-style font";
      homepage = "https://www.dafont.com/ds-digital.font";
      license = licenses.ofl;
    };
  };
}
