with (import <nixpkgs> {}).pkgs;
let pkg = haskellPackages.callPackage
            ({ mkDerivation, base, clckwrks, happstack-authenticate, hsp
             , hsx-jmacro, hsx2hs, jmacro, mtl, stdenv, text, web-plugins, cabal-install
             }:
             mkDerivation {
               pname = "clckwrks-theme-bootstrap";
               version = "0.4.0";
               src = ./.;
               buildDepends = [
                 base clckwrks happstack-authenticate hsp hsx-jmacro hsx2hs jmacro
                 mtl text web-plugins
               ];
               buildTools = [ cabal-install ];
               homepage = "http://www.clckwrks.com/";
               description = "simple bootstrap based template for clckwrks";
               license = stdenv.lib.licenses.bsd3;
             }) {};
in
  pkg.env
