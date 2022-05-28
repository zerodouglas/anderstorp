let pkgs = import ./nixpkgs.nix {};
in
pkgs.haskell.packages.ghc902.callCabal2nix "server" ./. {}
