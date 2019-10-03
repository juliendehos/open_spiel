with import <nixpkgs> {};

let 

  _python = python3;

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
    ];
    doCheck = false;
  };

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

in (_python.withPackages (ps: with ps; [
  absl-py 
  tensorflow
  _dm-sonnet 
  ipython 
  _tensorflow-probability 
  cvxopt 
  networkx 
  mock 
  matplotlib 
  scipy 
])).env

