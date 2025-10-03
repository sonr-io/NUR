{ lib, stdenv, fetchurl, autoPatchelfHook }:

stdenv.mkDerivation rec {
  pname = "snrd";
  version = "1.0.0";  # This will be updated by GoReleaser

  src = fetchurl {
    url = "https://github.com/sonr-io/sonr/releases/download/core/v${version}/snrd_linux_x86_64.tar.gz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";  # Update with actual hash
  };

  nativeBuildInputs = [ autoPatchelfHook ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp snrd $out/bin/
    ln -s $out/bin/snrd $out/bin/sonr

    runHook postInstall
  '';

  meta = with lib; {
    description = "Sonr blockchain daemon - decentralized identity network";
    homepage = "https://sonr.io";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
