{
  lib,
  stdenvNoCC,
  fetchurl,
  fetchFromGitHub,
  appimageTools,
  autoPatchelfHook,
  makeWrapper,
  kdePackages,
  gtk3,
  pipewire,
  openssl,
  python313Packages,
  python313,
  vapoursynth,
  avisynthplus,
  file,
  aften,
  libaom,
  fdk-aac-encoder,
  ffmpeg_6-headless,
  ffms,
  flac,
  kvazaar,
  lame,
  lsdvd,
  mediainfo,
  mkvtoolnix,
  gpac,
  mp4fpsmod,
  mplayer,
  vorbis-tools,
  opusTools,
  rav1e,
  sox,
  svt-av1,
  libvpx,
  x264,
  x265,
  boost183,
  p7zip,
  installVsScripts ? true,
  vsplugins ? [],
  extraConfigTxt ? '''',
}: let
  pname = "Hybrid";
  version = "2025.11.09.1";

  srcArchive = fetchurl {
    url = "https://www.selur.de/files/hybrid_downloads/Hybrid_${version}_AppImage.7z";
    sha256 = "sha256-O3Jo30jAYbGs1YrwUYhBZZKrTayEfhKpXbnSgTZ/UK0=";
  };

  appimageFile = stdenvNoCC.mkDerivation {
    name = "${pname}-appimage";
    src = srcArchive;
    nativeBuildInputs = [p7zip];

    unpackPhase = ''
      mkdir -p extracted
      7z x "$src" -oextracted >/dev/null 2>&1 || {
        echo "7z extraction failed; listing $src"
        ls -l "$src"
        exit 1
      }
      echo "extracted tree:"
      find extracted -maxdepth 5 -type f -print || true
    '';

    buildPhase = ''
      appimage=$(find extracted -type f -iname '*.AppImage' -print -quit)
      if [ -z "$appimage" ]; then
        echo "No .AppImage found; listing extracted files:" >&2
        find extracted -type f -print >&2
        exit 1
      fi
      chmod +x "$appimage"
      mkdir -p $out
      cp "$appimage" $out/${pname}.AppImage
    '';

    installPhase = ''
      true
    '';
  };

  srcAppImage = "${appimageFile}/${pname}.AppImage";

  vsScripts = fetchFromGitHub {
    owner = "Selur";
    repo = "VapoursynthScriptsInHybrid";
    rev = "master";
    hash = "sha256-EBNTTICUAZEZbVWBBfVMRjhlV46VAcJ1BrH4fsDE65M=";
  };

  vapoursynthWithPlugins = vapoursynth.passthru.withPlugins vsplugins;

  config =
    ''
      [General]
      avisynthExtensionPath=${avisynthplus}/lib
      vsPluginsPath=${vapoursynthWithPlugins}/lib
    ''
    + extraConfigTxt;
in
  stdenvNoCC.mkDerivation (finalAttrs: {
    inherit version pname;

    src = srcAppImage;

    dontUnpack = true;

    nativeBuildInputs = [
      kdePackages.wrapQtAppsHook
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [
      kdePackages.qtbase
      kdePackages.qtwayland
      kdePackages.qtmultimedia
      gtk3
      openssl
      python313Packages.vapoursynth
      vapoursynthWithPlugins
      avisynthplus
      pipewire
      file
      aften
      libaom
      fdk-aac-encoder
      ffmpeg_6-headless
      ffms
      flac
      kvazaar
      lame
      lsdvd
      mediainfo
      mkvtoolnix
      gpac
      mp4fpsmod
      mplayer
      vorbis-tools
      opusTools
      rav1e
      sox
      svt-av1
      libvpx
      x264
      x265
      boost183
    ];

    libraryPath = lib.makeLibraryPath [
      pipewire
      python313Packages.vapoursynth
      vapoursynthWithPlugins
    ];

    binPath = lib.makeBinPath [
      file
      python313
      vapoursynthWithPlugins
      avisynthplus
      aften
      libaom
      fdk-aac-encoder
      ffms
      ffmpeg_6-headless
      flac
      kvazaar
      lame
      lsdvd
      mediainfo
      mkvtoolnix
      gpac
      mp4fpsmod
      mplayer
      vorbis-tools
      opusTools
      rav1e
      sox
      svt-av1
      libvpx
      x265
      x264
    ];

    appimageContents = appimageTools.extractType2 {inherit (finalAttrs) pname version src;};

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin $out/usr/bin $out/.hybrid
      cp ${finalAttrs.appimageContents}/AppRun $out/AppRun
      chmod +x $out/AppRun

      cat > $out/bin/hybrid <<'EOF'
      #!/bin/sh
      HERE="$(dirname "$(readlink -f "$0")")"
      exec "$HERE/../AppRun" "$@"
      EOF
      chmod +x $out/bin/hybrid

      cp -t "$out/usr/bin" ${finalAttrs.appimageContents}/usr/bin/{bdsup2sub++,delaycut,faac,ffdcaenc,FLVExtractCL,FrameCounter,Hybrid,HybridLauncher,IdxSubCutter,SvtHevcEncApp,telxcc,tsMuxeR,vsViewer,xvid_encraw}
      ln -sf "${mediainfo}/bin/mediainfo" "$out/bin/MediaInfo"

      cat > $out/.hybrid/misc.ini <<"EOF"
      ${config}
      EOF

      install -Dm444 ${finalAttrs.appimageContents}/hybrid.desktop -t $out/share/applications
      install -Dm444 ${finalAttrs.appimageContents}/hybrid.png -t $out/share/pixmaps
      substituteInPlace $out/share/applications/hybrid.desktop \
        --replace-fail 'HybridLauncher' "hybrid"
      cp -r ${finalAttrs.appimageContents}/usr/share/icons $out/share

      runHook postInstall
    '';

    postFixup = ''
      wrapProgram $out/bin/hybrid \
        --set APPDIR $out/usr \
        --prefix LD_LIBRARY_PATH : "${finalAttrs.libraryPath}" \
        --prefix PYTHONPATH : "${vapoursynthWithPlugins}/${python313.sitePackages}" \
        --prefix PATH : "${finalAttrs.binPath}" \
        --run 'mkdir -p ~/.hybrid/vsscripts/' \
        ${
        if installVsScripts
        then " --run \"ln -sf ${vsScripts}/* ~/.hybrid/vsscripts/\" "
        else ""
      } \
        --run "ln -sf $out/.hybrid/misc.ini ~/.hybrid/"
    '';

    meta = {
      description = "A very complete gui for video encoding";
      homepage = "https://www.selur.de";
      downloadPage = "https://www.selur.de/downloads";
      license = "http://www.selur.de/licence";
      sourceProvenance = with lib.sourceTypes; [binaryNativeCode];
      maintainers = with lib.maintainers; [BBFifield];
      platforms = ["x86_64-linux"];
    };
  })
