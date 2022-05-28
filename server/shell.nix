let pkgs = import ./nixpkgs.nix {};
    server = import ./default.nix;
in
pkgs.mkShell {
	inputsFrom = [server.env];
	buildInputs = with pkgs; [
		    haskell-language-server
        cabal-install
        hlint
        ormolu
        ghcid
        ghc
        zlib
  ];
}
