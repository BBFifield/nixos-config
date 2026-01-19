{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  which,
  meson,
  ninja,
  python3,
  vapoursynth,
  ffmpeg_6-headless,
  l-smash,
  xxHash,
}:
stdenv.mkDerivation rec {
  pname = "vapoursynth-lsmashsource";
  version = "1266.0.0.0";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "L-SMASH-Works";
    rev = version;
    sha256 = "sha256-U4y/zXid5AFB8tVzwTJQKV2z4WBF+0+MPKSueiQTjQQ=";
  };

  # inputs (use `inherit` to keep the list compact where used)
  nativeBuildInputs = [pkg-config which meson ninja python3];
  buildInputs = [vapoursynth ffmpeg_6-headless l-smash xxHash];

  # Meson options collected in one place
  mesonFlags = [
    "-Dlibdir=lib"
    "--prefix=$out"
  ];

  # keep preConfigure minimal
  preConfigure = ''
    patchShebangs .
  '';

  configurePhase = ''
    cd VapourSynth
    export PKG_CONFIG_PATH="${ffmpeg_6-headless}/lib/pkgconfig:${l-smash}/lib/pkgconfig:$PKG_CONFIG_PATH"
    export MESON_BUILD_ROOT=build

    # join mesonFlags into a single string and pass to meson setup
    meson setup $MESON_BUILD_ROOT ${lib.concatStringsSep " " mesonFlags} || (cat meson-logs/meson-log.txt && false)
  '';

  buildPhase = ''
    meson compile -C build --verbose || (cat build/meson-logs/meson-log.txt && false)
  '';

  installPhase = ''
    meson install -C build --destdir=$out || (cat build/meson-logs/meson-log.txt && false)

    mkdir -p $out/lib/vapoursynth
    find build -type f -name 'libvs*.so' -exec cp -a {} $out/lib/vapoursynth/ \; || true
  '';

  # optional compile-time tweak if you hit implicit-declaration warnings
  # NIX_CFLAGS_COMPILE = "-D_GNU_SOURCE";

  passthru = {
    pluginPath = "$out/lib/vapoursynth";
  };

  meta = with lib; {
    description = "L-SMASH source plugin for VapourSynth (nixpkgs l-smash)";
    homepage = "https://github.com/HomeOfAviSynthPlusEvolution/L-SMASH-Works";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
