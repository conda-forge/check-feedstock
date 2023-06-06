#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* .

# Set in `conda_forge_build_setup` to `-j2 ${MAKEFLAGS}` and that breaks the build here :-(
export MAKEFLAGS=""

if [ ! -f configure ];
then
   autoreconf -i --force
fi

./configure --prefix=${PREFIX}

make
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR}" != "" ]]; then
make check || (cat tests/test-suite.log && exit 1)
fi
make install

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
