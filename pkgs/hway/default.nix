{ lib, stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "hway";
  version = "1.0.0";  # This will be updated by GoReleaser

  src = fetchurl {
    url = "https://github.com/sonr-io/sonr/releases/download/core/v${version}/hway_linux_x86_64.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Update with actual hash
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp hway $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Highway network component for Sonr";
    homepage = "https://sonr.io";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
