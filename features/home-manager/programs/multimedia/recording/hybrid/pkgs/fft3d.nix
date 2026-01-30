{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  fftwFloat,
  vapoursynth,
}:
stdenv.mkDerivation rec {
  pname = "VapourSynth-FFT3DFilter";
  version = "R2.AC3";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = pname;
    rev = version;
    sha256 = "sha256-onfqDYAneTKNeg0a/p6m1sgaKHdMZxSjslZC32Jc2mw=";
  };

  nativeBuildInputs = [meson ninja pkg-config];
  buildInputs = [fftwFloat vapoursynth];

  postPatch = ''
    substituteInPlace meson.build \
        --replace-fail "vapoursynth_dep.get_pkgconfig_variable('libdir')" "get_option('libdir')"
  '';

  meta = with lib; {
    description = "A VapourSynth port of FFT3DFilter";
    homepage = "https://github.com/AmusementClub/VapourSynth-FFT3DFilter";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [BBFifield];
    platforms = platforms.all;
  };
}
