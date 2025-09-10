{
  lib,
  stdenv,
  fetchFromGitHub,
  coreutils,
  python2,
  alsa-lib,
  libjack2,
  libsamplerate,
  lrdf,
  libsndfile,
  ladspa-sdk,
  glib,
  calf,
  binutils,
  glibc,
  tk-8_5,
  libogg,
  libvorbis,
  speex,
  fftw,
  guile,
  libxkbfile,
  util-macros,
  cmake,
  freetype,
  libXinerama,
  libXcursor,
  xrandr,
  llvm,
  boost,
  openssl,
  ncurses,
  xcbutilkeysyms,
  libsForQt5,
  gmp,
  mpfr,
  libmpc,
  which,
  pkg-config,
  ...
}:
stdenv.mkDerivation (finalAttrs:
    {
      pname = "radium";
      version = "7.5.71";

      src = fetchFromGitHub {
        owner = "kmatheussen";
        repo = "radium";
        rev = "e3367504d519f5962d25b34d91e4aa6ceeabc55e";
        hash = "sha256-V9fFARDo5J3y3IKwUgxwlV40RgmjuuI0WutPyhuZJYU=";
      };

      # Follow the README's order
      nativeBuildInputs = [
        python2
        glib
        binutils
        util-macros
        cmake
        which
        llvm
        pkg-config
        libsForQt5.wrapQtAppsHook
        libsForQt5.qtbase
        libsForQt5.qtwebengine
        libsForQt5.qtx11extras
        libsForQt5.qttools
      ];

      buildInputs = [
        alsa-lib
        libjack2
        libsamplerate
        lrdf
        libsndfile
        ladspa-sdk
        glibc
        tk-8_5
        libogg
        libvorbis
        speex
        fftw
        guile
        libxkbfile
        freetype
        libXinerama
        libXcursor
        xrandr
        llvm
        boost
        openssl
        ncurses
        xcbutilkeysyms
        gmp
        mpfr
        libmpc
      ];

      propagatedBuildInputs = [
        calf
      ];

      patchPhase = ''
        patchShebangs .
        substituteInPlace Makefile* \
          --replace-quiet "/usr/bin/env"  "${coreutils}/bin/env"
        sed -i 's|source $(dirname "''${0}")|source $PWD|g' *.sh
        sed -i 's|`which pkg-config`|''${pkg-config}/bin/pkg-config|g' *.sh
        sed -i 's|`which python2`|''${python2}/bin/python2|g' Makefile.*
        sed -i 's|`which python2`|''${python2}/bin/python2|g' *.sh
        cat bash_setup.sh
      '';

      configurePhase = ''
        export QMAKE_LIBS_ONLY_L_SHOULD_BE_EMPTY=1
        source ./configuration.sh
        export USE_QWEBENGINE=1
      '';

      buildPhase = ''
        make packages
        BUILDTYPE=RELEASE ./build_linux.sh -j 'nproc'
      '';

      installPhase = ''
        mkdir -p $out/bin
        cp bin/radium $out/bin/
      '';

      meta = {
        homepage = "http://users.notam02.no/~kjetism/radium/";
        description = "Music editor with a new type of interface";
        maintainers = with lib.maintainers; [
          kleha-tc
        ];
        platforms = lib.platforms.linux;
        license = lib.licenses.gpl2;
      };
    })
