with import <nixpkgs> {};

let 

  _gcc = gcc7;

  _stdenv = overrideCC stdenv _gcc;

  _python = python3;

  _tensorflow-probability = with _python.pkgs; buildPythonPackage rec {
    pname = "tensorflow-probability";
    version = "0.7.0";
    src = pkgs.fetchurl {
      url = "https://github.com/tensorflow/probability/archive/v0.7.tar.gz";
      sha256 = "0px2nxi51cilhi75l7km1wkdqazbgqpfshsmb9j1z3p6hkxqv4xa";
    };
    propagatedBuildInputs = [
      cloudpickle
      decorator
      numpy
      six
    ];
    doCheck = false;
  };

  _dm-sonnet = with _python.pkgs; buildPythonPackage rec {
    name = "dm-sonnet-1.32";
    src = pkgs.fetchurl {
      url = "https://github.com/deepmind/sonnet/archive/v1.32.tar.gz";
      sha256 = "0lfgasqrikl5jvbhnmk42mnxbwj202ri3wn7llpyplimspk50ywi";
    };
    propagatedBuildInputs = [
      absl-py
      contextlib2
      semantic-version
      wrapt
    _tensorflow-probability 
    ];
    doCheck = false;
  };

  _pyenv = _python.withPackages (ps: with ps; [
    absl-py 
    attrs
    tensorflow
    _dm-sonnet 
    ipython 
    _tensorflow-probability 
    cvxopt 
    networkx 
    mock 
    matplotlib 
    scipy 
  ]);

in _stdenv.mkDerivation {
  name = "open_spiel";
  src = ./.;
  buildInputs = [
    _pyenv
    cmake
    _gcc
  ];
}

