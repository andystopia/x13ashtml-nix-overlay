# Nix x13binary build


As of today nixpkgs marks the CRAN R package `x13binary` as broken, this 
is unfortunate since I need that library. I've constructed a flake overlay
here which allows `x13binary` to build from the source Fortran, so that
the package doesn't try to fetch it from the binary repository. 


## Usage

I'm a flake user so:


### 1. Add to Inputs
```nix
inputs.x13ashtml.url = "github:andystopia/x13ashtml-nix-overlay";
```

### 2. Add `x13ashtml` to outputs list 


### 3. Apply the overlay provided here

and then however you get your nixpkgs for your platform, in my case:

```nix
nixpkgsFor = forAllSystems (system:
  import nixpkgs {
    inherit system;
    overlays = [x13ashtml.overlays.default];
});
```

### 4. Your packages which depend on x13binary ought to work.


## Notes.

This approach is not extensively tested, and it just pulls a random version
from the GitHub repo, instead of from CRAN like it probably should; perhaps
it should pull from CRAN instead, but alas, I'm hopeful this will 
be sufficient for my use case. As always, PRs welcome :)


Where this is so simple here, if someone knows how to add it to nixpkgs upstream
please do :D

