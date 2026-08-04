{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  jdk17,
  gradle,
  libicns,
  librsvg,
  _7zz,
  python3,
}:

let
  jdk = jdk17;
in

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "skeleton-viewer";
  version = "4.3.6";

  src = fetchFromGitHub {
    owner = "EsotericSoftware";
    repo = "spine-runtimes";
    rev = "4.3";
    hash = "sha256-O0Sr1rLTgjFO1J/RuX9Uz4xTCHLb+5806wW+N+PBZlI=";
  };

  iconSrc = fetchurl {
    url = "https://esotericsoftware.com/files/branding/spine_branding.zip";
    hash = "sha256-m1Wrx1ExFnsWhcP4yV6mbToX7//r7hAKcTivYstwTkQ=";
  };

  sourceRoot = "source/spine-libgdx";

  nativeBuildInputs = [
    jdk
    gradle
    libicns
    librsvg
    _7zz
    python3
  ];

  dontStrip = true;

  makeIconScript = ./make-icon.py;

  preBuild = ''
    mkdir -p icons
    7zz e "$iconSrc" spine_badge.svg -so > icons/spine_badge.svg

    python3 "$makeIconScript" icons/spine_badge.svg icons/spine_icon_macos.svg

    for size in 16 32 64 128 256 512 1024; do
      rsvg-convert -w $size -h $size icons/spine_icon_macos.svg -o icons/icon_''${size}x''${size}.png
    done

    png2icns icons/app.icns \
      icons/icon_16x16.png \
      icons/icon_32x32.png \
      icons/icon_64x64.png \
      icons/icon_128x128.png \
      icons/icon_256x256.png \
      icons/icon_512x512.png \
      icons/icon_1024x1024.png
  '';

  buildPhase = ''
    runHook preBuild

    export JAVA_HOME=${jdk}
    export GRADLE_USER_HOME=$(mktemp -d)
    ./gradlew --no-daemon :spine-skeletonviewer:jar

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/Applications

    ${jdk}/bin/jpackage \
      --input spine-skeletonviewer/build/libs \
      --name "Skeleton Viewer" \
      --main-jar spine-skeletonviewer-${finalAttrs.version}-SNAPSHOT.jar \
      --main-class com.esotericsoftware.spine.SkeletonViewer \
      --type app-image \
      --icon icons/app.icns \
      --dest $out/Applications

    runHook postInstall
  '';

  meta = {
    description = "Standalone Spine Skeleton Viewer for macOS";
    homepage = "https://esotericsoftware.com/spine-skeleton-viewer";
    license = lib.licenses.unfree; # Spine Runtimes License
    platforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ aaronjheng ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
