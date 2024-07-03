{stdenv}:
stdenv.mkDerivation {
  name = "ft_nvim";
  src = ../..;
  installPhase = ''
    mkdir -p $out
    cp -r $src/* $out/
  '';
}
