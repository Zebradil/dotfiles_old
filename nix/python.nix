with import <nixpkgs> {};

python37.withPackages (ps: with ps; [ pip pipenv powerline ipython flake8 black isort rope awscli ])
