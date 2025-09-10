let
  pkgs = import <nixpkgs> {};
in
pkgs.callPackage ./package.nix {
  qtbase = pkgs.libsForQt5.qtbase;
  qttools = pkgs.libsForQt5.qttools;
  qtwebkit = pkgs.libsForQt5.qtwebkit;
  qtx11extras = pkgs.libsForQt5.qtx11extras;
}
