{
  lib,
  stdenvNoCC,
  fetchzip,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lucida-console";
  version = "1.0.0";

  src = fetchzip {
    url = "https://font.download/dl/font/lucida-console.zip";
    hash = "sha256-960JCrsLnziQCuLfYweNiffGuq5pSEFNIAmKe427rV4=";
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 -t $out/share/fonts/lucida-console.ttf lucon.ttf

    runHook postInstall
  '';

  meta = {
    description = "Lucida Console Font";
    homepage = "https://learn.microsoft.com/en-us/typography/font-list/lucida-console";
    license = lib.licenses.unfree;
  };
})
