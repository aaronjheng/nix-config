{
  lib,
  stdenv,
  fetchurl,
}:

let
  manifest = lib.importJSON ./manifest.json;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "clash-rs";
  version = manifest.version;

  src =
    let
      system = stdenv.hostPlatform.system;
    in
    fetchurl (manifest.assets.${system} or (throw "Unsupported system: ${system}"));

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    install -D $src $out/bin/clash
  '';

  meta = {
    description = "Custom protocol, rule based network proxy software";
    homepage = "https://github.com/Watfaq/clash-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "clash";
  };
})
