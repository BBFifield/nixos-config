{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  boost,
  vapoursynth,
  opencl-headers,
  ocl-icd,
  openclSupport ? false,
}:
stdenv.mkDerivation rec {
  pname = "vapoursynth-eedi3";
  version = "r4";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "VapourSynth-EEDI3";
    rev = version;
    hash = "sha256-MIUf6sOnJ2uqGw3ixEHy1ijzlLFkQauwtm1vfgmYmcg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs =
    [
      boost
      vapoursynth
    ]
    ++ lib.optionals openclSupport [
      ocl-icd
      opencl-headers
    ];

  postPatch = ''
    substituteInPlace meson.build \
      --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  mesonFlags = [(lib.mesonBool "opencl" openclSupport)];

  meta = {
    description = "Filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-EEDI3";
    license = with lib.licenses; [gpl2Plus];
    maintainers = with lib.maintainers; [snaki];
    platforms = lib.platforms.x86_64;
  };
}
