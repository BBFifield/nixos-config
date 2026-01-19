{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  pkg-config,
  audiofile,
  SDL2,
  libGL,
  discord-rpc,
  hexdump,
  sm64baserom,
  p7zip,
  copyDesktopItems,
  makeDesktopItem,
  withDynos ? true,
  withTexturePack ? true,
  region ? "us",
}: let
  dynos = fetchFromGitHub {
    owner = "Render96";
    repo = "ModelPack";
    rev = "dynos_and_goddard";
    hash = "sha256-ry62Gss27/m6FCDi8zrQWov4tHEVZYRqVnzgC7GCNxc=";
  };
  texturePack = fetchFromGitHub {
    owner = "GhostlyDark";
    repo = "SM64-Reloaded-PC";
    rev = "master";
    hash = "sha256-fNZZ2YZJdNU9GUfwzOXvrvd92C9xNPl/PC427nTV58E=";
  };
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "render96ex";
    version = "alpha";
    src = fetchFromGitHub {
      owner = "Render96";
      repo = "Render96ex";
      rev = "alpha";
      hash = "sha256-gkugSARLhrbeXVIFux9wmdMwawZfNri1XYnQiCffGwQ=";
    };

    patches = [./fix-format-security.patch ./fix-zip-timestamps.patch];

    nativeBuildInputs = [
      python3
      pkg-config
      hexdump
      p7zip
      copyDesktopItems
    ];

    buildInputs = [
      audiofile
      SDL2
      libGL
      discord-rpc
    ];

    enableParallelBuilding = true;

    makeFlags =
      [
        "VERSION=${region}"
        "DISCORDRPC=1"
      ]
      ++ lib.optionals stdenv.hostPlatform.isDarwin [
        "OSX_BUILD=1"
      ];

    preBuild =
      ''
        patchShebangs extract_assets.py
        ln -s ${sm64baserom} ./baserom.${region}.z64
      ''
      + lib.optionalString withDynos ''
        7z x ${dynos}/Render96_DynOs/Render96_DynOs_v3.25.7z -odynos/packs
      '';

    installPhase =
      ''
        mkdir -p $out/bin
        mkdir -p $out/share/render96ex
        cp -r build/${region}_pc/* $out/share/render96ex/
        mv $out/share/render96ex/sm64.${region}.f3dex2e $out/share/render96ex/render96ex

        cat > $out/bin/render96ex <<EOF
        #!/bin/sh
        exec $out/share/render96ex/render96ex "$@"
        EOF

        chmod +x $out/bin/render96ex
      ''
      + lib.optionalString withTexturePack ''
        cp -r ${texturePack}/gfx $out/share/render96ex/res/
      ''
      + ''
        runHook postInstall
      '';

    postInstall = ''
      mkdir -p $out/share/pixmaps
      install -Dm644 ${./render96ex.png} $out/share/pixmaps/render96ex.png
      # cp ${./render96ex.png} $out/share/pixmaps/render96ex.png
    '';

    desktopItems = [
      (makeDesktopItem {
        name = "render96ex";
        icon = "render96ex";
        exec = "render96ex";
        comment = finalAttrs.meta.description;
        genericName = "render96ex";
        desktopName = "render96ex";
        categories = ["Game"];
      })
    ];

    meta = {
      homepage = "https://github.com/Render96/Render96ex";
      description = "Fork of SM64 Port with additional features";
      mainProgram = "render96ex";
      platforms = ["x86_64-linux"];
      maintainers = with lib.maintainers; [BBFifield];
      license = with lib.licenses; [
        mit
        unfree
      ];
    };
  })
