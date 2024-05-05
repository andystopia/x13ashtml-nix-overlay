
{
  description = "An overlay to support the broken build x13binary package for R";


  outputs = {
    self,
  }: let
    x13Overlay = final: pkgs: let
      x13GithubSrc = pkgs.fetchFromGitHub {
        owner = "x13org";
        repo = "x13binary";
        rev = "840feff3772b851b3b33fafbeefc1d5f3092ab5d";
        hash = "sha256-8ILTUtITeevg+vPvCs5k+a8c8T4gOj+MizFCqod2mu4=";
      };

      # build from the github
      x13buildGithub = pkgs.stdenv.mkDerivation {
        src = x13GithubSrc;
        name = "x13build";
        phases = ["buildPhase" "installPhase"];

        DYLIB_LD = "gfortran";

        buildPhase = ''
          mkdir ./x13
          cp -r $src/* ./x13/
          chmod -R u+w ./x13/

          # now make the binary, and install it
          # to the correct place for the real R
          # package build
          make --directory=./x13/src
        '';

        installPhase = ''
          mkdir $out
          cp -R ./x13/* $out/
        '';
        nativeBuildInputs = [pkgs.gfortran];
      };

      x13RBuild = pkgs.rPackages.buildRPackage {
        name = "x13binary";
        src = x13buildGithub;
      };
    in {
      rPackages = pkgs.rPackages.override {
        overrides = {
          x13binary = x13RBuild;
        };
      };
    };
  in {
		overlays.default = x13Overlay;
	};
}
